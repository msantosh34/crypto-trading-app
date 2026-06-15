source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

# Core Rails
gem "rails", "~> 7.0.0"
gem "puma", "~> 5.0"
gem "pg", "~> 1.1"

# API & Serialization
gem "jbuilder"
gem "active_model_serializers", "~> 0.10.0"
gem "rack-cors"

# Authentication & Authorization
gem "rails_jwt_auth", "~> 0.10.0"
gem "devise", "~> 4.8.0"
gem "pundit", "~> 2.2.0"

# Storage
gem "aws-sdk-s3", require: false
gem "active-storage-aws-sdk"

# Background Jobs & Caching
gem "sidekiq", "~> 6.5.0"
gem "redis", "~> 4.5"
gem "hiredis", "~> 0.6.0"

# Admin Dashboard
gem "rails_admin", "~> 3.0"

# Payment Gateway
gem "razorpay", "~> 2.8.0"

# External APIs
gem "httparty", "~> 0.21.0"
gem "faraday", "~> 2.0"

# Validation & Security
gem "email_validator", "~> 2.0"
gem "strong_parameters"

# Pagination
gem "kaminari", "~> 1.2.0"
gem "api-pagination", "~> 4.8.0"

# JSON Schema Validation
gem "json-schema", "~> 2.8.0"

# API Documentation
gem "rswag", "~> 2.5.0"
gem "rswag-ui", "~> 2.5.0"
gem "rswag-api", "~> 2.5.0"

# Utilities
gem "dotenv-rails", "~> 2.7"
gem "paranoid_enum", "~> 0.2.0"
gem "aasm", "~> 5.2.0"
gem "audited", "~> 5.0"

# Monitoring & Logging
gem "sentry-rails"
gem "sentry-sidekiq"

group :development, :test do
  gem "rspec-rails", "~> 6.0"
  gem "factory_bot_rails", "~> 6.2"
  gem "faker", "~> 2.20"
  gem "pry-rails", "~> 0.3.9"
  gem "pry-byebug", "~> 3.10"
end

group :test do
  gem "shoulda-matchers", "~> 5.1"
  gem "webmock", "~> 3.14"
  gem "vcr", "~> 6.1"
  gem "simplecov", "~> 0.21.0"
  gem "rspec-sidekiq", "~> 3.1"
end

group :development do
  gem "web-console", "~> 4.1"
  gem "listen", "~> 3.3"
  gem "spring"
  gem "rubocop", "~> 1.28"
  gem "rubocop-rails", "~> 2.14"
end
