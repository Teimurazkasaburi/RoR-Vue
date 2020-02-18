class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authenticate_user, except: [:show, :index, :search, :delete_image_attachment]


  def index
    @posts = Post.scorable.order(score: :desc, promotion_updated_at: :desc).paginate(:page => params[:page], :per_page => 8)
    render :index
  end

  def show
    if current_user && (@post.user != current_user)
      @post.update_attributes(view_count: @post.view_count+1)
    else
      @post.update_attributes(view_count: @post.view_count+1)
    end
    render :show
  end

  def search
    args = {}
    args[:unpublish] = {not: true}

    args[:price] = {}
    args[:price][:gte] = params[:min_price] if params[:min_price].present?
    args[:price][:lte] = params[:max_price] if params[:max_price].present?


    args[:bedrooms] = {}
    args[:bedrooms] = params[:bedrooms] if params[:bedrooms].present?
    args[:bedrooms][:gte] = params[:min_bedrooms] if params[:min_bedrooms].present?
    args[:bedrooms][:lte] = params[:max_bedrooms] if params[:max_bedrooms].present?

    args[:bathrooms] = {}
    args[:bathrooms][:gte] = params[:min_bathrooms] if params[:min_bathrooms].present?
    args[:bathrooms][:lte] = params[:max_bathrooms] if params[:max_bathrooms].present?

    args[:purpose] = params[:purpose] if params[:purpose].present?

    args[:lga] = params[:lga] if params[:lga].present?
    args[:state] = params[:state] if params[:state].present?

    args[:type_of_property] = params[:type_of_property] if params[:type_of_property].present?

    args[:use_of_property] = params[:use_of_property] if params[:use_of_property].present?

    query = params[:q].presence || "*"

    @posts =  Post.search query, order: { score: {order: :desc, unmapped_type: 'float'}, promotion_updated_at: {order: :desc, unmapped_type: 'long'}}, fields: [:lga, :state, :area, :tags, :reference_id], where: args, aggs: { purpose: {}, type_of_property: {}, use_of_property: {}, price: {}, bedrooms: {}, bathrooms: {}, state:{}, lga:{}}, page: params[:page], per_page: 8
    render :index
  end

  def create
    @user = current_user
    max_post = @user.subscription.max_post

      if max_post > 0
        if params[:images].present?

          @post = current_user.posts.build(post_params)
          @post.images.attach(params[:images])
            if @post.save
              MetaDatum.create_default_for!(@post)
              @user.subscription.update_attributes(max_post: max_post -1 )
              render :created, status: :created
            else
              render json: @post.errors.full_messages, status: :unprocessable_entity
            end
        else
          response = {status: "Please attach an image and try again"}
          render json: response, status: :forbidden
        end
      else
        response = {status: "You need to buy a subscription"}
        render json: response, status: :unprocessable_entity
      end
  end


    def update
      @post.images.attach(params[:images]) if params[:images].present?
        if @post.update!(post_params)
          render :show
        else
          render json: @post.errors, status: :unprocessable_entity
        end

    end


  def destroy
    if @post.user == current_user || current_user.admin
      @post.destroy
      else
        render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
    end
  end

  def delete_image_attachment
    @delete_image = ActiveStorage::Attachment.find(params[:id])
    if @delete_image.purge
      render json: "Deleted"
    else
      render json: @delete_image.errors
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find_by_permalink(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:price, :duration, :street,:lga,:state,:area, :title, :purpose, :use_of_property, :type_of_property, :bedrooms, :bathrooms, :toliets, :description, :video_link,:square_meters, :unpublish )
    end

end
