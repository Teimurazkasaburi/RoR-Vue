class Admin::MetaDataController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_admin

  def index
    @meta_data = MetaDatum.preload(:post)
    if params[:q].present?
      posts = Post.search(params[:q],
                          fields: [
                            :title, :street, :lga, :state,
                            :area, :tags, :reference_id
                          ],
                          load: false)

      @meta_data = @meta_data.where(post_id: posts.results.map(&:id))
    end
    @meta_data = @meta_data.where(edited: true) if (params[:mode] == 'edited')
    @meta_data = @meta_data.paginate(page: params[:page], per_page: 12)

    render :index
  end

  def available_posts
    query = params[:q].presence || '*'

    @posts = Post.search(
      query,
      order: {
        created_at: :desc
      },
      fields: [
        :title, :street, :lga,
        :state, :area, :tags,
        :reference_id
      ],
      misspellings: {
        edit_distance: 2,
        below: 1
      },
      where: {
        id: {
          not: MetaDatum.pluck(:post_id)
        }
      },
      aggs: {
        lga: {},
        type_of_property: {},
        state: {}
      },
      page: params[:page],
      per_page: 12
    )

    render :available_posts
  end

  def template
    # NOTE: The default values are set on initialize
    @meta_datum = MetaDatum.new.generate_default_values
    render json: @meta_datum.attributes.merge(post_title: @meta_datum.post&.title)
  end

  def show
    @meta_datum = MetaDatum.find(params[:id])
    render json: @meta_datum.attributes.merge(post_title: @meta_datum.post&.title)
  end

  def update
    @meta_datum = MetaDatum.find(params[:id])
    @meta_datum.assign_attributes(meta_attributes)

    if @meta_datum.save
      @meta_datum.update(edited: true)
      render json: @meta_datum.attributes.merge(post_title: @meta_datum.post&.title)
    else
      render json: @meta_datum.errors, status: :bad_request
    end
  end

  def upload_images
    @meta_datum = MetaDatum.find(params[:id])
    if meta_attributes[:seo_image].blank? && meta_attributes[:seo_og_image].blank?
      render json: {error: 'Image is missing'}, status: :bad_request
      return
    end

    if meta_attributes[:seo_image].present?
      @meta_datum.seo_image.purge
      @meta_datum.seo_image.attach(meta_attributes[:seo_image])
      @meta_datum.image_src = Rails.application.routes.url_helpers.image_url(@meta_datum.seo_image.id, host: ENV.fetch('API_URL', 'https://backendapi.2dotsproperties.com'))
    end
    if meta_attributes[:seo_og_image].present?
      @meta_datum.seo_og_image.purge
      @meta_datum.seo_og_image.attach(meta_attributes[:seo_og_image])
      @meta_datum.og_image = Rails.application.routes.url_helpers.image_url(@meta_datum.seo_og_image.id, host: ENV.fetch('API_URL', 'https://backendapi.2dotsproperties.com'))
    end

    if @meta_datum.save
      render json: @meta_datum.attributes.merge(post_title: @meta_datum.post&.title)
    else
      render json: @meta_datum.errors, status: :bad_request
    end
  end

  private

  def meta_attributes
    params.permit(:post_id, :site,
                  :title, :description,
                  :keywords, :charset,
                  :reverse, :noindex,
                  :nofollow, :noarchive,
                  :canonical, :image_src,
                  :og_title, :og_type, :og_url,
                  :og_image, :og_video_director,
                  :og_video_writer,
                  :twitter_card,
                  :twitter_site,
                  :twitter_creator,
                  :seo_image,
                  :seo_og_image)
  end

  def ensure_admin
    return if current_user.admin?

    render json: { message: "You're not authorized to access this resource" }, status: :unauthorized
  end
end
