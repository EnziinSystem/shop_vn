require_relative 'boot'

require 'rails/all'
require 'twocheckout'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Shop
  class Application < Rails::Application

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths += %W(#{config.root}/lib)
    config.time_zone = 'London'

    config.active_job.queue_adapter = :sidekiq

    config.after_initialize do
      ActiveMerchant::Billing::Base.mode = PAYPAL_CONFIG['mode'].to_sym
      ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(PAYPAL_OPTIONS)
    end

  end
end
