class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :agents, :purpose, :destroy_avatar, :make_admin, :verify_agent]
  before_action :authenticate_user, only: [:update, :show, :verify_user, :user_stats, :change_password]

  def index

  end

  def create
    if User.where(username: params[:user][:username], email: params[:user][:email]).exists?
      render json: { message: "Account already exist" }, status: :conflict
    else
      user = User.new(user_params)
      if user.save
        # auth_token = Knock::AuthToken.new payload: { sub: user.id, email: user.email, name: user.f_name }
        # render json: auth_token, status: :created
        sub = user.build_subscription(created_at: Time.now, max_post: 10, expiring_date: Time.now+30.day)
        if sub.save
          render json: { message: "Subscription created" }
        else
          render json: { message: "Subscription not created" }
        end

        UserMailer.welcome(user).deliver_later

      else
          render json:   { message: user.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end
  end

  def show
    @admin = current_user if current_user.admin
  end

  def agents
    render :agent
  end

  def search_agents
    only_agents = User.agents
    if params[:q].present?
      @result = User.agents.ransack(company_start: params[:q]).result(distinct: true)
      @agents = @result.paginate(:page => params[:page], :per_page => 12).order(:company)
    else
      @agents = only_agents.paginate(:page => params[:page], :per_page => 12).order("RANDOM()")
    end
    render :agents
  end

  def purpose
    p = params[:q]
    @posts = @user.posts.where(purpose: p).paginate(:page => params[:page], :per_page => 4)
  end

  def user_stats
    @user = current_user
    render :stats
  end

  def update
    if @user == current_user || current_user.admin

      if params[:user][:avatar].present?
        @user.avatar.purge
        @user.avatar.attach(params[:avatar])
      end

      if @user.update!(user_params)
        render :show
      else
        render json: { message: @user.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
    end
  end

  def destroy
    if @user == current_user || current_user.admin
      @user.destroy
    else
        render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
    end
  end

  def make_admin
    status = params[:status] if params[:status].present?
    if current_user.super_user
      @user.update_attributes(admin: status)
    else
      render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
    end
  end

  def verify_agent
    if current_user.admin
      status = params[:status]
      @user.update_attributes(verified: status)
    else
      render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
    end
  end

  def destroy_avatar
    if @user == current_user || current_user.admin
      @user.avatar.purge
    else
      render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
    end
  end

  def iforgot
    @user = User.find_by(email: params[:user][:email])
    if @user.present?
      temp_password = SecureRandom.hex(10)
      @user.update!(:password => temp_password )
      UserMailer.iforgot(@user, temp_password).deliver_later
      response = { message: "A temporary password has been sent to your email" }
      render json: response, status: :ok
    else
      response = { message: "#{params[:user][:email]} doesn't exist. Please enter a valid email" }
      render json: response, status: :unprocessable_entity
    end
  end

  def change_password
    @user = current_user

    if  params[:user][:old_password].present? && params[:user][:new_password].present? && @user.authenticate(params[:user][:old_password])
      @user.update!(:password => params[:user][:new_password] )
        response = { message: "Success" }
        render json: response, status: :ok
      puts params[:user][:new_password]
    else
      response = { message: "Failed" }
        render json: response, status: :unprocessable_entity
      puts params[:user][:old_password]

    end
  end

  def verify_user
    if current_user
      response = {status: true}
      render json: response, status: :ok
    else
      response = {status: false}
      render json: response, status: :ok
    end
  end

  def verify_user_data
    @user = current_user

    if (@user.address && @user.phone.present?)
      response = {status: true}
      render json: response, status: :ok
    else
      response = {status: false}
      render json: response, status: :unprocessable_entity
    end
  end

  def check_max_post
    @user = current_user

    if (@user.subscription.max_post > 0)
      response = {status: true}
      render json: response, status: :ok
    else
      response = {status: "You need to buy a subscription"}
      render json: response, status: :unprocessable_entity
    end
  end

  private
  def set_user
    @user = User.find_by_username(params[:id])
  end

  def user_params
    params.require(:user).permit(:f_name, :l_name, :old_password, :new_password, :avatar, :username, :email, :password, :phone, :whatsapp, :about, :company, :account_type, :country_code, :country_code_whatsapp, address:[:state, :city, :street])
  end
end
