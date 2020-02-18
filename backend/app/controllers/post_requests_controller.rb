class PostRequestsController < ApplicationController
  before_action :set_post_request, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user

  
    def index
      @post_requests = PostRequest.all.order(created_at: :desc)
    end
  
    def show
      @current_user = current_user
    end
  
    def search
      args = {}

      args[:state] = params[:state] if params[:state].present?
      args[:lga] = params[:lga] if params[:lga].present?
      args[:user_id] = User.find_by_username(params[:username]).id if params[:username].present?

      query = params[:q].presence || "*"

      @post_requests =  PostRequest.search query, order: { created_at: :desc}, fields: [:state, :lga], where: args, aggs: { state: {}, lga: {}, user_id: {}}, page: params[:page], per_page: 12
      render :index
    end


    def create
      @post_request = current_user.post_requests.build(post_request_params)
  
      if @post_request.save
        render :show, status: :created
      else
        render json: @post_request.errors.full_messages.to_sentence, status: :unprocessable_entity
      end
    end
  
  
    def update
        if @post_request.update(post_request_params)
          render :show
        else
          render json: @post_request.errors, status: :unprocessable_entity
        end
    end
  
  
    def destroy
      @post_request.destroy
    end
  
    private
    def set_post_request
      @post_request = PostRequest.find(params[:id])
    end
  
    def post_request_params
      params.require(:post_request).permit(:purpose, :budget, :type_of_property, :state, :lga, :area, :description, :bedrooms )
    end
end
