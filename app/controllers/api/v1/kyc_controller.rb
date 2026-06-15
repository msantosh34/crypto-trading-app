module Api
  module V1
    class KycController < ApplicationController
      before_action :authenticate_user!

      # GET /api/v1/kyc/status
      def status
        kyc_service = KYCService.new(current_user)
        render json: { status: kyc_service.kyc_status }, status: :ok
      end

      # POST /api/v1/kyc/submit
      def submit
        kyc_service = KYCService.new(current_user)
        begin
          kyc = kyc_service.submit_kyc(
            params[:aadhaar_document],
            params[:pan_document],
            params[:selfie_document]
          )
          render json: { message: 'KYC submitted successfully', kyc_id: kyc.id }, status: :created
        rescue StandardError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/kyc
      def show
        kyc = current_user.kyc
        if kyc
          render json: KYCSerializer.new(kyc).to_json, status: :ok
        else
          render json: { error: 'KYC not found' }, status: :not_found
        end
      end
    end
  end
end
