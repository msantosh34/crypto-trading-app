# Database seeds for development

# Create currencies
puts "Creating currencies...
%w[INR BTC ETH DOGE XRP].each do |code|
  Currency.find_or_create_by!(code: code) do |currency|
    currency.name = "#{code} Currency"
    currency.is_crypto = code != 'INR'
  end
end

# Create trading pairs
puts "Creating trading pairs...
btc = Currency.find_by(code: 'BTC')
eth = Currency.find_by(code: 'ETH')
doge = Currency.find_by(code: 'DOGE')
xrp = Currency.find_by(code: 'XRP')
inr = Currency.find_by(code: 'INR')

[btc, eth, doge, xrp].each do |crypto|
  TradingPair.find_or_create_by!(base_currency: crypto, quote_currency: inr)
end

# Create admin user
puts "Creating admin user...
admin = User.find_or_create_by!(email: 'admin@cryptotrading.com') do |user|
  user.password = 'AdminPassword123!'
  user.password_confirmation = 'AdminPassword123!'
  user.role = :admin
end

# Create sample users
puts "Creating sample users...
5.times do |i|
  user = User.find_or_create_by!(email: "user#{i+1}@example.com") do |u|
    u.password = 'Password123!'
    u.password_confirmation = 'Password123!'
    u.role = :user
  end
  
  # Create KYC
  KYC.find_or_create_by!(user: user) do |kyc|
    kyc.status = :approved
  end
end

# Create initial crypto prices
puts "Creating initial crypto prices...
Currency.crypto.each do |currency|
  CryptoPrice.create!(
    currency: currency,
    price: rand(50000..100000),
    market_cap: rand(1_000_000_000..10_000_000_000),
    volume_24h: rand(100_000_000..1_000_000_000),
    change_24h: rand(-5.0..5.0),
    fetched_at: Time.current
  )
end

puts "Seed data created successfully!"
