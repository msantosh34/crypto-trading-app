module Api
  module V1
    class WithdrawalsController < ApplicationController
      before_action :authenticate_user!

      # GET /api/v1/withdrawals
      def index
        withdrawals = current_user.withdrawals.recent.page(params[:page]).per(50)
        render json: { withdrawals: ActiveModelSerializers::SerializableResource.new(withdrawals, each_serializer: WithdrawalSerializer), total: current_user.withdrawals.count }, status: :ok
      end

      # POST /api/v1/withdrawals
      def create
        currency_code = params.require(:currency_code)
        amount = params.require(:amount).to_f
        wallet_address = params.require(:wallet_address)

        withdrawal_service = WithdrawalService.new(current_user)
        begin
          withdrawal = withdrawal_service.create_withdrawal(currency_code, amount, wallet_address)
          render json: { message: 'Withdrawal initiated', withdrawal_id: withdrawal.id }, status: :created
        rescue StandardError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/withdrawals/:id
      def show
        withdrawal = current_user.withdrawals.find(params[:id])
        render json: WithdrawalSerializer.new(withdrawal).to_json, status: :ok
      end
    end
  end
end
