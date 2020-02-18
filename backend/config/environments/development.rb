Rails.application.configure do

  config.time_zone = "West Central Africa"
  config.active_record.default_timezone = :local
  config.active_record.time_zone_aware_attributes = false



  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true


  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end


  config.active_storage.service = :local
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker



  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_options = {from: 'no-reply@2dotsproperties.com'}




  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
  # config.action_mailer.smtp_settings = {
  #   :address => 'in-v3.mailjet.com',
  #   :port => 587,
  #   :user_name => '13adcfa25d74de181dea03e1be919d92',
  #   :password => Rails.application.credentials.mailjet,
  #   :authentication => 'login',
  #   :enable_starttls_auto => true
  # }
end
