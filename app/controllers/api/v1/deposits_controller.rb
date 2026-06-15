module Api
  module V1
    class DepositsController < ApplicationController
      before_action :authenticate_user!

      # GET /api/v1/deposits
      def index
        deposits = current_user.deposits.recent.page(params[:page]).per(50)
        render json: { deposits: ActiveModelSerializers::SerializableResource.new(deposits, each_serializer: DepositSerializer), total: current_user.deposits.count }, status: :ok
      end

      # POST /api/v1/deposits/initiate
      def initiate
        amount = params.require(:amount).to_f
        deposit_service = DepositService.new(current_user)
        begin
          result = deposit_service.create_razorpay_order(amount)
          render json: result, status: :created
        rescue StandardError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/deposits/confirm
      def confirm
        deposit_id = params.require(:deposit_id)
        razorpay_payment_id = params.require(:razorpay_payment_id)
        razorpay_signature = params.require(:razorpay_signature)

        deposit_service = DepositService.new(current_user)
        begin
          if deposit_service.confirm_deposit(deposit_id, razorpay_payment_id, razorpay_signature)
            render json: { message: 'Deposit confirmed successfully' }, status: :ok
          else
            render json: { error: 'Deposit confirmation failed' }, status: :unprocessable_entity
          end
        rescue StandardError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/deposits/:id
      def show
        deposit = current_user.deposits.find(params[:id])
        render json: DepositSerializer.new(deposit).to_json, status: :ok
      end
    end
  end
end
