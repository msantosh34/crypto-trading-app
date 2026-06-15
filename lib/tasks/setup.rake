namespace :setup do
  desc "Initialize the application"
  task initialize: :environment do
    puts "Creating default currencies..."
    %w[INR BTC ETH DOGE XRP].each do |code|
      Currency.find_or_create_by!(code: code, name: "#{code} Currency", is_crypto: code != 'INR')
    end

    puts "Creating trading pairs..."
    Currency.where(is_crypto: true).each do |crypto|
      TradingPair.find_or_create_by!(base_currency: crypto, quote_currency: Currency.find_by(code: 'INR'))
    end

    puts "Setup completed successfully!"
  end
end
