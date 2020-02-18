SitemapGenerator::Sitemap.default_host = "https://2dotsproperties.com" # Your Domain Name
SitemapGenerator::Sitemap.public_path = 'tmp/sitemap'
# Where you want your sitemap.xml.gz file to be uploaded.
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new( 
aws_access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
aws_secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
fog_provider: 'AWS',
fog_directory: '2dots',
fog_region: 'eu-west-2'
)

# The full path to your bucket
SitemapGenerator::Sitemap.sitemaps_host = "https://2dots.s3.amazonaws.com"

SitemapGenerator::Sitemap.create do
    add "/search/commercial-properties-for-sale-in-abuja", :changefreq => 'weekly'
    add "/search/commercial-properties-for-sale-in-portharcourt", :changefreq => 'weekly'
    add "/search/commercial-property-for-sale-in-lagos", :changefreq => 'weekly'
    add "/search/flats-and-apartments-for-rent-in-abuja", :changefreq => 'weekly'
    add "/search/flats-and-apartments-for-rent-in-lagos", :changefreq => 'weekly'
    add "/search/flats-and-apartments-for-rent-in-lekki", :changefreq => 'weekly'
    add "/search/flats-and-apartments-for-rent-in-portharcourt", :changefreq => 'weekly'
    add "/search/flats-and-apartments-for-sale-in-abuja", :changefreq => 'weekly'
    add "/search/flats-and-apartments-for-sale-in-lagos", :changefreq => 'weekly'
    add "/search/flats-and-apartments-for-sale-in-lekki", :changefreq => 'weekly'
    add "/search/flats-and-apartments-for-sale-in-portharcourt", :changefreq => 'weekly'
    add "/search/houses-for-rent-in-abuja", :changefreq => 'weekly'
    add "/search/houses-for-rent-in-lagos", :changefreq => 'weekly'
    add "/search/houses-for-rent-in-lekki", :changefreq => 'weekly'
    add "/search/houses-for-rent-in-portharcourt", :changefreq => 'weekly'
    add "/search/houses-for-sale-in-abuja", :changefreq => 'weekly'
    add "/search/houses-for-sale-in-lagos", :changefreq => 'weekly'
    add "/search/houses-for-sale-in-lekki", :changefreq => 'weekly'
    add "/search/houses-for-sale-in-portharcourt", :changefreq => 'weekly'
    add "/search/lands-for-sale-in-abuja", :changefreq => 'weekly'
    add "/search/lands-for-sale-in-lagos", :changefreq => 'weekly'
    add "/search/lands-for-sale-in-lekki", :changefreq => 'weekly'
    add "/search/lands-for-sale-in-portharcourt", :changefreq => 'weekly'
    add "/search/new-developments-properties-for-sale-in-lagos", :changefreq => 'weekly'
    add "/search/properties-for-sale-in-abuja", :changefreq => 'weekly'
    add "/search/properties-for-sale-in-Lagos", :changefreq => 'weekly'
    add "/search/properties-in-nigeria", :changefreq => 'weekly'
    add "/search/properties-in-port-harcourt", :changefreq => 'weekly'
    add "/search/shortlets-flats-and-apartments-in-lekki", :changefreq => 'weekly'

  # Add all posts:
    Post.find_each do |post|
      add "/properties/#{post.permalink}", :lastmod => post.updated_at
    end

  # Add all forum post:
    Forum.find_each do |forum|
      add "/forum/#{forum.permalink}", :lastmod => forum.updated_at
    end
  # Add all forum agents:
    User.find_each do |user|
      add "/agents/#{user.username}", :lastmod => user.updated_at
    end
end
