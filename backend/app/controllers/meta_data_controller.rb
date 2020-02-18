class MetaDataController < ApplicationController
  def show
    @meta_datum = MetaDatum.find_by(post_id: params[:post_id])

    if @meta_datum.present?
      render json: @meta_datum.for_nuxt
    else
      render json: MetaDatum.new.for_nuxt
    end
  end
end
