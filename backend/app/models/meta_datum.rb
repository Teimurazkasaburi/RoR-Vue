class MetaDatum < ApplicationRecord
  belongs_to :post

  has_one_attached :seo_image
  has_one_attached :seo_og_image

  validates :post, presence: true

  def full_title
    result = [title, site].reject(&:blank?)
    result.reverse! if self.reverse?

    result.join(' - ')
  end

  def for_nuxt
    result = attributes.merge('title' => full_title,
                              'og_description' => description,
                              'twitter_description' => description,
                              'twitter_image' => og_image)
                       .except('id', 'post_id', 'reverse', 'noindex', 'nofollow', 'noarchive', 'created_at', 'updated_at')

    robots = []
    robots.push('noindex') if noindex?
    robots.push('nofollow') if nofollow?
    robots.push('noarchive') if noarchive?

    return result unless robots.any?
    result = result.merge('robots' => robots.join(', '))

    result
  end

  def generate_default_values
    self.site ||= '2Dots Properties'
    self.charset ||= "utf-8"
    self.og_type ||= "website"
    self.reverse ||= false
    self.noindex ||= false
    self.nofollow ||= false
    self.noarchive ||= false
    self
  end

  def self.create_default_for!(post = Post.new)
    return if post.blank? || post.new_record?
    post_url = "#{ENV.fetch('FRONTEND_URL', 'https://2dotsproperties.com')}/properties/#{post.permalink}"
    base_host = ENV.fetch('API_URL', 'https://backendapi.2dotsproperties.com')

    if post.images.first.present? && base_host.present?
      image_url = Rails.application.routes.url_helpers.post_image_url(post, post.images.first.id, host: base_host)
    end

    post.build_meta_datum(
      title: post.title,
      site: '2Dots Properties',
      image_src: image_url,
      og_image: image_url,
      og_title: post.title,
      description: post.description,
      canonical: post_url,
      keywords:  [
        post.lga,
        post.state,
        post.type_of_property,
        post.permalink.gsub('-', ' ')
      ].join(', '),
      og_url: post_url
    ).save!
  end
end
