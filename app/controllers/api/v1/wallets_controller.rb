module Api
  module V1
    class WalletsController < ApplicationController
      before_action :authenticate_user!

      # GET /api/v1/wallets
      def index
        wallet_service = WalletService.new(current_user)
        wallets = wallet_service.get_all_wallets
        render json: { wallets: wallets }, status: :ok
      end

      # GET /api/v1/wallets/:currency_code
      def show
        currency_code = params.require(:id)
        wallet = current_user.wallets.joins(:currency).find_by(currencies: { code: currency_code })
        if wallet
          render json: WalletSerializer.new(wallet).to_json, status: :ok
        else
          render json: { error: 'Wallet not found' }, status: :not_found
        end
      end

      # GET /api/v1/wallets/:currency_code/history
      def history
        currency_code = params.require(:currency_code)
        limit = params.fetch(:limit, 50).to_i
        offset = params.fetch(:offset, 0).to_i

        wallet_service = WalletService.new(current_user)
        ledgers = wallet_service.get_wallet_history(currency_code, limit, offset)
        render json: { ledgers: ActiveModelSerializers::SerializableResource.new(ledgers, each_serializer: WalletLedgerSerializer) }, status: :ok
      end
    end
  end
end
