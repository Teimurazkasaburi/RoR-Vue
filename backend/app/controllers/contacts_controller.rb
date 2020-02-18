class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:index]
  
    def index
      if current_user.admin
        @contacts = Contact.where(owner: "ADMIN").order(created_at: :desc).paginate(:page => params[:page], :per_page => 8)
        render :index
      else
        render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
      end
    end
  
    def show
    end
  
    def create
      @contact= Contact.create(contact_params)
  
      if @contact.save
        if params[:contact][:owner] != "ADMIN"
          @user = User.find_by_username(params[:contact][:owner])
          ContactMailer.contact_form(@user.email, @contact).deliver_later
        else
          ContactMailer.contact_form('support@2dotsproperties.com', @contact).deliver_later
        end
        # puts params[:contact][:owner], "From created"

        render json: {message: "Message sent"}, status: :created
      else
        render json: @contact.errors, status: :unprocessable_entity
      end
    end
  
  
    def update
        if @contact.update(contact_params)
          render :show
        else
          render json: @contact.errors, status: :unprocessable_entity
        end
    end
  
  
    def destroy
      @contact.destroy
    end
  
    private
    def set_contact
      @contact = Contact.find(params[:id])
    end
  
    def contact_params
      params.require(:contact).permit(:phone, :email, :name, :body, :owner)
    end
end
