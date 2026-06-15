module Api
  module V1
    class TradesController < ApplicationController
      before_action :authenticate_user!

      # POST /api/v1/trades/buy/preview
      def buy_preview
        trading_pair_id = params.require(:trading_pair_id)
        quantity_or_amount = params.require(:quantity_or_amount).to_f
        order_type = params.fetch(:order_type, 'quantity') # quantity or amount

        trading_service = TradingService.new(current_user)
        begin
          preview = trading_service.create_buy_order(trading_pair_id, quantity_or_amount, order_type.to_sym)
          render json: preview, status: :ok
        rescue StandardError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/trades/buy/execute
      def execute_buy
        order_id = params.require(:order_id)
        trading_service = TradingService.new(current_user)
        begin
          trade = trading_service.execute_buy_order(order_id)
          render json: TradeSerializer.new(trade).to_json, status: :created
        rescue StandardError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/trades/sell/preview
      def sell_preview
        trading_pair_id = params.require(:trading_pair_id)
        quantity_or_amount = params.require(:quantity_or_amount).to_f
        order_type = params.fetch(:order_type, 'quantity')

        trading_service = TradingService.new(current_user)
        begin
          preview = trading_service.create_sell_order(trading_pair_id, quantity_or_amount, order_type.to_sym)
          render json: preview, status: :ok
        rescue StandardError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/trades/sell/execute
      def execute_sell
        order_id = params.require(:order_id)
        trading_service = TradingService.new(current_user)
        begin
          trade = trading_service.execute_sell_order(order_id)
          render json: TradeSerializer.new(trade).to_json, status: :created
        rescue StandardError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/trades/history
      def history
        limit = params.fetch(:limit, 50).to_i
        offset = params.fetch(:offset, 0).to_i
        trading_service = TradingService.new(current_user)
        trades = trading_service.get_trade_history(limit, offset)
        render json: { trades: ActiveModelSerializers::SerializableResource.new(trades, each_serializer: TradeSerializer) }, status: :ok
      end

      # GET /api/v1/trades/:id
      def show
        trade = current_user.trades.find(params[:id])
        render json: TradeSerializer.new(trade).to_json, status: :ok
      end
    end
  end
end
