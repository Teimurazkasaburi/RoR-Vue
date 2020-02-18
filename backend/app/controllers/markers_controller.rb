class MarkersController < ApplicationController
  before_action :set_marker, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user
  
    def index
      @bookmarks = current_user.markers.bookmarks.order(created_at: :desc).paginate(:page => params[:page], :per_page => 8)
      render :index
    end
  
    def show
    end
  

    # POST /posts/:post_id/markers
    def create
      @post = Post.find_by_permalink(params[:post_id])
      
      if Marker.where(user_id: current_user.id, post_id: @post.id).exists?
        render json: { message: "Already Saved" }, status: :conflict
      else
        @marker = @post.markers.build(marker_params)
        @marker.user = current_user
        if @marker.save
          render  json: { unsave_url: "posts/#{@marker.post.permalink}/markers/#{@marker.id}", message: "Saved" }, status: :created
        else
          render json: { message: "Unauthorized! Please sign in." }, status: :unprocessable_entity
        end
      end
    end
  
    # PATCH/PUT /posts/:post_id/markers/1
    # def update
    #     if @marker.update(marker_params)
    #       render json: { message: "Updated" },status: :ok
    #     else
    #       render json: @marker.errors, status: :unprocessable_entity
    #     end
    # end
  
    # DELETE /posts/:post_id/markers/1
    def destroy
      @post = Post.find_by_permalink(params[:post_id])

      if Marker.where(user_id: current_user.id, post_id: @post.id).exists?
        @marker.destroy
      else
        render json: { message: "Unauthorized" }, status: :unauthorized
      end
    end
  
    private
    def set_marker
      @marker = Marker.find(params[:id])
    end
  
    def marker_params
      params.require(:marker).permit(:type_of_maker, :saved)
    end
end
