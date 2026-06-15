# Scheduled tasks for Sidekiq
require 'sidekiq-scheduler'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/1' }

  config.server_middleware do |chain|
    chain.add Sentry::Sidekiq::ServerMiddleware
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/1' }
  config.client_middleware do |chain|
    chain.add Sentry::Sidekiq::ClientMiddleware
  end
end

# Schedule recurring tasks
Sidekiq::Cron::Job.create!(
  name: 'fetch-crypto-prices',
  cron: '*/5 * * * *',  # Every 5 minutes
  class: 'FetchCryptoPricesJob'
)
