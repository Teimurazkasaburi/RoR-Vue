Rails.application.configure do

  config.time_zone = "West Central Africa"
  config.active_record.default_timezone = :local
  config.active_record.time_zone_aware_attributes = false


  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.active_storage.service = :digitalocean
  config.log_level = :debug
  config.log_tags = [ :request_id ]
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
  config.active_record.dump_schema_after_migration = false



  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_options = {from: 'no-reply@2dotsproperties.com'}




  config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
  config.action_mailer.smtp_settings = {
    :address => 'in-v3.mailjet.com',
    :port => 587,
    :user_name => '13adcfa25d74de181dea03e1be919d92',
    :password => Rails.application.credentials.mailjet,
    :authentication => 'login',
    :enable_starttls_auto => true
  }
end
