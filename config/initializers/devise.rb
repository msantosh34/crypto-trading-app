# Devise configuration
Devise.setup do |config|
  config.secret_key = ENV['DEVISE_SECRET_KEY'] || 'your-secret-key'
  config.mailer_sender = ENV['SMTP_FROM_EMAIL']
  config.omniauth_path_prefix = '/auth'
end
