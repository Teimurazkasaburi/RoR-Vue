namespace :meta_data do
  desc "Create the default SEO-records for existing posts"
  task create_default: :environment do
    Post.without_meta.each do |post|
      MetaDatum.create_default_for!(post)
    end
  end
end
