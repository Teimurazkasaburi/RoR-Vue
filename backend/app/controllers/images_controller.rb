class ImagesController < ApplicationController
  def show
    if params[:id].present?
      post_image
    else
      native_image
    end
  rescue StandardError
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def post_image
    post = Post.find_by!(permalink: params[:id])
    image = post.images.find(params[:image_id])
    image_url = rails_representation_url(ActiveStorage::Attachment.last.variant(combine_options: Post.large_options), only_path: true)
    redirect_to rails_blob_path(image, disposition: "inline")
  end

  def native_image
    image = ActiveStorage::Attachment.find(params[:image_id])
    image_url = rails_representation_url(ActiveStorage::Attachment.last.variant(combine_options: Post.large_options), only_path: true)
    redirect_to rails_blob_path(image, disposition: "inline")
  end
end
