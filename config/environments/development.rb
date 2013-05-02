Homefinance2::Application.configure do
  config.cache_classes = false

  config.whiny_nils = true

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.active_support.deprecation = :log

  config.action_dispatch.best_standards_support = :builtin

  config.active_record.mass_assignment_sanitizer = :strict

  config.active_record.auto_explain_threshold_in_seconds = 0.5

  config.assets.compress = false
  config.assets.debug = true

  config.force_ssl = false

  #config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  #config.action_mailer.delivery_method = :smtp
  #config.action_mailer.perform_deliveries = true
  #config.action_mailer.raise_delivery_errors = true
  #config.action_mailer.default :charset => "utf-8"
  #config.action_mailer.smtp_settings = {
  #    :address              => "smtp.gmail.com",
  #    :port                 => 587,
  #    :domain               => 'homefinance.herokuapp.com',
  #    :user_name            => 'tormozoid48@gmail.com',
  #    :password             => 'tormozoid',
  #    :authentication       => 'plain',
  #    :enable_starttls_auto => true  }
end
