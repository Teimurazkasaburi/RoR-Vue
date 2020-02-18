class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:index, :update, :destroy]
  before_action :authenticate_user, except: [:brands]
  
    def index
      if @user == current_user || current_user.admin
          @brands = @user.brands.paginate(:page => params[:page], :per_page => 2).order(created_at: :desc)
      render :index
      else
        render json:   { message: "You're not authorized to access this resources" }, status: :unauthorized
      end
    end

    def brands
      @brands = Brand.home.order("RANDOM()")
      # render :brands
    end
  
    def show
    end
  
    def create
      @brand= current_user.brands.build(brand_params)
  
      if @brand.save
        render :show, status: :created
      else
        render json: @brand.errors, status: :unprocessable_entity
      end
    end
  
  
    def update
      if @user == current_user || current_user.admin
        if @brand.update(brand_params)
          render :show
        else
          render json: @brand.errors, status: :unprocessable_entity
        end
      else
        render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
      end
    end
  
  
    def destroy
      if @user == current_user || current_user.admin
        @brand.destroy
      else
        render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
      end
    end
  
    private
    def set_brand
      @brand = Brand.find_by_ref_no(params[:id])
    end

    def set_user
      @user = User.find_by_username(params[:id])
    end
  
    def brand_params
      params.require(:brand).permit(:url, :amount, :logo, :duration )
    end
end
