# JWT Configuration
RailsJwtAuth.configure do |config|
  # Authentication class
  config.model_name = 'User'
  config.simultaneous_sessions = 1000
  config.token_exp_time = ENV.fetch('JWT_EXP_TIME', 7.days)
end
