require 'rails/all'

Bundler.require(*Rails.groups)

module CryptoTradingApi
  class Application < Rails::Application
    config.load_defaults 7.0

    # API only mode
    config.api_only = true

    # Middleware for API
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete]
      end
    end

    # Autoload paths
    config.autoload_paths << Rails.root.join('lib')

    # JSON error responses
    config.action_dispatch.show_exceptions = :none
    config.debug_exception_response_format = :default

    # Generate timestamps in UTC
    config.time_zone = 'UTC'
    config.active_record.default_timezone = :utc

    # Sidekiq configuration
    config.active_job.queue_adapter = :sidekiq
  end
end
