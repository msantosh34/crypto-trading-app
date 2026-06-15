# Sentry configuration for error tracking
Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.environment = Rails.env
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
end
