Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.

  Paperclip.options[:command_path] = '/usr/bin'

  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
        'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.

  config.assets.debug = true
  config.serve_static_assets = false

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  config.active_job.queue_adapter = :sidekiq

  config.active_job.queue_name_prefix = 'shop'

  config.active_job.queue_name_delimiter = "_"

  config.paperclip_defaults = {
      storage: :fog,
      fog_credentials: {
          provider: 'Local',
          local_root: "#{Rails.root}/public"
      },
      fog_directory: '',
      fog_host: ''
  }

  # config.paperclip_defaults = {
  #     storage: :s3,
  #     s3_credentials: {
  #         bucket: ENV["AWS_S3_BUCKET"],
  #         access_key_id: ENV["AWS_ACCESS_KEY_ID"],
  #         secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
  #         s3_region: ENV["AWS_S3_REGION"]
  #     }
  # }

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.action_mailer.default_url_options = {host: 'shop.enziin.com'}

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
      address: 'smtp.gmail.com',
      port: 587,
      domain: 'shop.enziin.com',
      user_name: 'oceandemy@gmail.com',
      password: 'torglpmshtsyjeyr',
      authentication: 'plain',
      enable_starttls_auto: true
  }

  # config.action_mailer.smtp_settings = {
  #     address: ENV['AWS_SES_SMTP'],
  #     port: 587,
  #     enable_starttls_auto: true,
  #     user_name: ENV['AWS_SES_USERNAME'],
  #     password: ENV['AWS_SES_PASSWORD']
  # }

end
