class SendNotificationJob
  include Sidekiq::Worker
  sidekiq_options retry: 3, queue: 'low'

  def perform(notification_type, user_id, data = {})
    user = User.find(user_id)

    case notification_type
    when 'kyc_approved'
      UserMailer.kyc_approved_notification(user).deliver_now
    when 'kyc_rejected'
      UserMailer.kyc_rejected_notification(user, data['reason']).deliver_now
    when 'deposit_success'
      deposit = Deposit.find(data['deposit_id'])
      UserMailer.deposit_notification(user, deposit).deliver_now
    when 'withdrawal_success'
      withdrawal = Withdrawal.find(data['withdrawal_id'])
      UserMailer.withdrawal_completed(user, withdrawal).deliver_now
    when 'trade_executed'
      trade = Trade.find(data['trade_id'])
      UserMailer.trade_notification(user, trade).deliver_now
    end
  end
end
