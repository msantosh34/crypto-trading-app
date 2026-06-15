Rails.application.routes.draw do
  # Health check
  get 'health', to: 'health#check'

  namespace :api do
    namespace :v1 do
      # Authentication routes
      post 'auth/register', to: 'auth#register'
      post 'auth/login', to: 'auth#login'
      post 'auth/logout', to: 'auth#logout'
      post 'auth/password-reset', to: 'auth#password_reset'
      post 'auth/password-reset-confirm', to: 'auth#password_reset_confirm'
      post 'auth/change-password', to: 'auth#change_password'

      # User routes
      get 'users/profile', to: 'users#profile'
      put 'users/profile', to: 'users#update'
      get 'users/:id', to: 'users#show'

      # KYC routes
      get 'kyc/status', to: 'kyc#status'
      post 'kyc/submit', to: 'kyc#submit'
      get 'kyc', to: 'kyc#show'

      # Wallet routes
      get 'wallets', to: 'wallets#index'
      get 'wallets/:id', to: 'wallets#show'
      get 'wallets/:currency_code/history', to: 'wallets#history'

      # Deposit routes
      get 'deposits', to: 'deposits#index'
      post 'deposits/initiate', to: 'deposits#initiate'
      post 'deposits/confirm', to: 'deposits#confirm'
      get 'deposits/:id', to: 'deposits#show'

      # Withdrawal routes
      get 'withdrawals', to: 'withdrawals#index'
      post 'withdrawals', to: 'withdrawals#create'
      get 'withdrawals/:id', to: 'withdrawals#show'

      # Trade/Order routes
      post 'trades/buy/preview', to: 'trades#buy_preview'
      post 'trades/buy/execute', to: 'trades#execute_buy'
      post 'trades/sell/preview', to: 'trades#sell_preview'
      post 'trades/sell/execute', to: 'trades#execute_sell'
      get 'trades/history', to: 'trades#history'
      get 'trades/:id', to: 'trades#show'

      # Price routes
      get 'prices/current', to: 'prices#current'
      get 'prices/all', to: 'prices#all'
      get 'prices/history', to: 'prices#history'

      # Admin routes
      namespace :admin do
        get 'dashboard', to: 'admin#dashboard'
        get 'kyc/pending', to: 'admin#pending_kyc'
        put 'kyc/:id/approve', to: 'admin#approve_kyc'
        put 'kyc/:id/reject', to: 'admin#reject_kyc'
        post 'currencies', to: 'admin#create_currency'
        post 'trading-pairs', to: 'admin#create_trading_pair'
      end
    end
  end

  # Sidekiq admin dashboard
  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
  end
  mount Sidekiq::Web => '/sidekiq'
end
