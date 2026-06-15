module Api
  module V1
    class AdminController < ApplicationController
      before_action :authenticate_user!
      before_action :authorize_admin!

      # GET /api/v1/admin/dashboard
      def dashboard
        render json: {
          total_users: User.count,
          total_deposits: Deposit.where(status: :completed).sum(:amount),
          total_withdrawals: Withdrawal.where(status: :completed).sum(:amount),
          pending_kyc: KYC.pending.count,
          active_trades: Trade.where(status: :completed).count
        }, status: :ok
      end

      # GET /api/v1/admin/kyc/pending
      def pending_kyc
        kyc_list = KYC.pending.page(params[:page]).per(50)
        render json: { kyc_list: ActiveModelSerializers::SerializableResource.new(kyc_list, each_serializer: KYCSerializer), total: KYC.pending.count }, status: :ok
      end

      # PUT /api/v1/admin/kyc/:id/approve
      def approve_kyc
        kyc = KYC.find(params[:id])
        kyc_service = KYCService.new(kyc.user)
        if kyc_service.approve_kyc
          render json: { message: 'KYC approved' }, status: :ok
        else
          render json: { error: 'Failed to approve KYC' }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/admin/kyc/:id/reject
      def reject_kyc
        kyc = KYC.find(params[:id])
        reason = params.require(:reason)
        kyc_service = KYCService.new(kyc.user)
        if kyc_service.reject_kyc(reason)
          render json: { message: 'KYC rejected' }, status: :ok
        else
          render json: { error: 'Failed to reject KYC' }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/admin/currencies
      def create_currency
        code = params.require(:code)
        name = params.require(:name)
        is_crypto = params.fetch(:is_crypto, false)
        currency = Currency.create!(code: code, name: name, is_crypto: is_crypto)
        render json: CurrencySerializer.new(currency).to_json, status: :created
      end

      # POST /api/v1/admin/trading-pairs
      def create_trading_pair
        base_currency_id = params.require(:base_currency_id)
        quote_currency_id = params.require(:quote_currency_id)
        pair = TradingPair.create!(base_currency_id: base_currency_id, quote_currency_id: quote_currency_id)
        render json: TradingPairSerializer.new(pair).to_json, status: :created
      end

      private

      def authorize_admin!
        render json: { error: 'Unauthorized' }, status: :forbidden unless current_user.admin?
      end
    end
  end
end
