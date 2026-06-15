class FetchCryptoPricesJob
  include Sidekiq::Worker
  sidekiq_options retry: 5, queue: 'default'

  def perform
    begin
      PriceService.fetch_prices
      Rails.logger.info "Crypto prices fetched successfully at #{Time.current}"
    rescue StandardError => e
      Rails.logger.error "Error fetching crypto prices: #{e.message}"
      raise e
    end
  end
end
