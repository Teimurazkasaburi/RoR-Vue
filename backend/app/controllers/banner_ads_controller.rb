class BannerAdsController < ApplicationController
  before_action :set_banner_ad, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:index, :update, :destroy]
  before_action :authenticate_user, except: [:banner]

  
    def index
      if @user == current_user || current_user.admin
        @banner_ads = @user.banner_ads.paginate(:page => params[:page], :per_page => 2).order(created_at: :desc)
        render :index
      else
        render json:   { message: "You're not authorized to access this resources" }, status: :unauthorized
      end

    end
  
    def banner
      banner_type = params[:type] if params[:type].present?
      case 
        when banner_type == "SMALL"
          @banner = BannerAd.small
        when banner_type == "MEDIUM"
          @banner = BannerAd.medium
        when banner_type == "LARGE"
          @banner = BannerAd.large
        else
          render json: {message: "Unknown Banner"}
      end
    end

    def show
    end
  
    def create
      @banner_ad= current_user.banner_ads.build(banner_ad_params)
  
      if @banner_ad.save
        render :show, status: :created
      else
        render json: @banner_ad.errors, status: :unprocessable_entity
      end
    end
  
  
    def update
      if @user == current_user || current_user.admin
        if @banner_ad.update(banner_ad_params)
          render :show
        else
          render json: @banner_ad.errors, status: :unprocessable_entity
        end
      else
        render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
      end
    end
  
  
    def destroy
      if @user == current_user || current_user.admin
        @banner_ad.destroy
      else
        render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
      end
    end
  
    private
    def set_banner_ad
      @banner_ad = BannerAd.find_by_ref_no(params[:id])
    end
  
    def set_user
      @user = User.find_by_username(params[:id])
    end

    def banner_ad_params
      params.require(:banner_ad).permit(:amount, :url, :banner_type, :duration, :sidebar_image, :home_image, :home_mobile_image, :listing_image, :listing_mobile_image)
    end
end
