class AdminsController < ApplicationController
 before_action :authenticate_user

  def home
    if current_user.admin
      @admin = current_user
      render :admin
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end

  def verify_admin
    if current_user.admin
      response = {status: true}
      render json: response, status: :ok
    else
      response = {status: "You need to buy a subscription"}
      render json: response, status: :unauthorized
    end
  end

  def admins
    if current_user.super_user
      @users = User.where(admin: true).order(last_logged_in: :desc).paginate(:page => params[:page], :per_page => 12)
      render :users
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end

  def users_stats
    if current_user.admin
      @free = Subscription.where(plan: "FREE").count
      @basic = Subscription.where(plan: "BASIC").count
      @classic = Subscription.where(plan: "CLASSIC").count
      @custom = Subscription.where(plan: "CUSTOM").count
      @pro = Subscription.where(plan: "PRO").count
      render :stats
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end


  def search_users
    if current_user.admin
      args = {}

      args[:admin] = {not: true}
      args[:super_user] = {not: true}
      args[:account_type] = params[:account_type] if params[:account_type].present?

      args[:posts_count] = {}
      args[:posts_count][:gte] = params[:posts_count] if params[:posts_count].present?

      users = User.where(admin: false)

      query = params[:q].presence || "*"
      @users = users.search query, order: {last_logged_in: :desc}, fields: [:company, :f_name, :l_name, :email, :phone, :username], misspellings: {edit_distance: 2, below: 1},  where: args, aggs: { account_type: {}, posts_count: {} }, page: params[:page], per_page: 12
      render :users
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end

  def users_by_plan
    if current_user.admin
      @users = User.joins(:subscription).where(subscriptions: {plan: params[:plan]}).order(last_logged_in: :desc).paginate(:page => params[:page], :per_page => 12)
      render :users
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end

  def verified_agents
    if current_user.admin
      @users = User.where(verified: true).paginate(:page => params[:page], :per_page => 12).order(last_logged_in: :desc)
      render :users
    else
      render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
    end
  end


  def banners
    if current_user.admin
      if params[:q].present?
        @result = BannerAd.ransack(ref_no_start: params[:q]).result(distinct: true)
        @banner_ads = @result.paginate(:page => params[:page], :per_page => 8).order(created_at: :desc)
      else
        @banner_ads = BannerAd.where(status: "ACTIVE").paginate(:page => params[:page], :per_page => 8).order(created_at: :desc)
      end
      render :banners
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end


  def new_banner
    if current_user.admin
      user = User.find_by_username(params[:username])
      duration = params[:duration]
      exp = Time.now + duration.to_i * 30.day
      @banner_ad = user.banner_ads.build(
                                          url: params[:url],
                                          amount: params[:amount],
                                          duration: duration,
                                          banner_type: params[:banner_type],
                                          sidebar_image: params[:sidebar_image],
                                          home_image: params[:home_image],
                                          home_mobile_image: params[:home_mobile_image],
                                          listing_image: params[:listing_image],
                                          listing_mobile_image: params[:listing_mobile_image],
                                          expiring_date: exp,
                                          status: "ACTIVE"
                                        )
      if @banner_ad.save
        render json: { message: "Created" }, status: :created
        SubscriptionMailer.bannerAd(user, @banner_ads).deliver_later
      else
        render json: @banner_ad.errors, status: :unprocessable_entity
      end
    else
      render json:   { message: "You're not authorized to perform this action" }, status: :unauthorized
    end
  end



  def brands
    if current_user.admin
      if params[:q].present?
        @result = Brand.ransack(ref_no_start: params[:q]).result(distinct: true)
        @brands = @result.paginate(:page => params[:page], :per_page => 8).order(created_at: :desc)
      else
        @brands = Brand.home.paginate(:page => params[:page], :per_page => 8).order(created_at: :desc)
      end
      render :brands
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end


  def new_brand
    if current_user.admin
      user = User.find_by_username(params[:username])
      duration = params[:duration]
      exp = Time.now + duration.to_i * 30.day
      @brand = user.brands.build(
                                  url: params[:url],
                                  amount: params[:amount],
                                  logo: params[:logo],
                                  duration: duration,
                                  status:"ACTIVE",
                                  expiring_date: exp
                                )
        if @brand.save
          render json: { message: "Created" }, status: :created
          SubscriptionMailer.brand(user, @brand).deliver_later
        else
          render json: @brand.errors, status: :unprocessable_entity
      end
    else
      render json:   { message: "You're not authorized to perform this action" }, status: :unauthorized
    end
  end


  def search_posts
    if current_user.admin
      args = {}

      args[:type_of_property] = params[:type_of_property] if params[:type_of_property].present?
      args[:lga] = params[:lga] if params[:lga].present?
      args[:state] = params[:state] if params[:state].present?

      query = params[:q].presence || '*'

      @posts =  Post.search query, order: { created_at: :desc}, fields: [:title, :street, :lga, :state, :area, :tags, :reference_id],misspellings: {edit_distance: 2, below: 1}, where: args, aggs: { lga: {}, type_of_property: {}, state: {}}, page: params[:page], per_page: 12
      render :posts
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end

  def reported
    if current_user.admin
      @reports = Marker.where(type_of_maker: "REPORTED" ).order(created_at: :desc).paginate(:page => params[:page], :per_page => 12)
      render :reports
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end


  def upgrade
    if current_user.admin
      plan = params[:plan]
      user = User.find_by_username( params[:username] )

      case
        when plan == "CLASSIC"
          value( plan, 5000, 10, 15, user )
        when plan == "PRO"
          value( plan, 12500, 20, 40, user )
        when plan == "CUSTOM"
          value( plan, 20000, 30, 60, user )
        when plan == "BASIC"
          value( plan, 2000, 5, 5, user )
        else
          render "Unknown plan"
      end
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end


  private

  def value plan, amount, boost, priority, user
    subscription = user.build_subscription( plan: plan, amount: amount, expiring_date: Time.now + 30.day, start_date: Time.now, boost: boost, priorities: priority, max_post: 1000 )
    if subscription.save
      render json: { status: "subscription created" }
      transaction = user.transactions.build( amount: amount, transaction_for: plan, duration: 1, status: "PAID" )
      if transaction.save
        SubscriptionMailer.invoice(user, transaction, subscription).deliver_later
      end
    end
  end

end
