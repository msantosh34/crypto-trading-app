class ProcessWithdrawalJob
  include Sidekiq::Worker
  sidekiq_options retry: 3, queue: 'critical'

  def perform(withdrawal_id)
    withdrawal = Withdrawal.find(withdrawal_id)
    return unless withdrawal.processing?

    begin
      # Simulate blockchain processing
      # In production, this would call actual blockchain APIs
      transaction_hash = generate_transaction_hash
      withdrawal.update!(status: :completed, blockchain_transaction_hash: transaction_hash)
      UserMailer.withdrawal_completed(withdrawal.user, withdrawal).deliver_later
      Rails.logger.info "Withdrawal #{withdrawal_id} processed successfully"
    rescue StandardError => e
      Rails.logger.error "Error processing withdrawal #{withdrawal_id}: #{e.message}"
      raise e
    end
  end

  private

  def generate_transaction_hash
    SecureRandom.hex(32)
  end
end
