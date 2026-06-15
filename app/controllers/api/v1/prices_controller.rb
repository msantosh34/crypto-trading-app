module Api
  module V1
    class PricesController < ApplicationController
      # GET /api/v1/prices/current
      def current
        currency_code = params.require(:currency_code)
        price = PriceService.get_current_price(currency_code)
        if price
          render json: { currency_code: currency_code, price: price }, status: :ok
        else
          render json: { error: 'Price not found' }, status: :not_found
        end
      end

      # GET /api/v1/prices/all
      def all
        prices = CryptoPrice.latest.includes(:currency).map do |price|
          { currency_code: price.currency.code, price: price.price, fetched_at: price.fetched_at }
        end
        render json: { prices: prices }, status: :ok
      end

      # GET /api/v1/prices/history
      def history
        currency_code = params.require(:currency_code)
        hours = params.fetch(:hours, 24).to_i
        prices = PriceService.get_price_history(currency_code, hours)
        render json: { prices: ActiveModelSerializers::SerializableResource.new(prices, each_serializer: CryptoPriceSerializer) }, status: :ok
      end
    end
  end
end
