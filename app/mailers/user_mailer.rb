class UserMailer < ApplicationMailer
  default from: ENV['SMTP_FROM_EMAIL']

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Crypto Trading Platform')
  end

  def kyc_submitted_notification(user)
    @user = user
    mail(to: @user.email, subject: 'KYC Submitted Successfully')
  end

  def kyc_approved_notification(user)
    @user = user
    mail(to: @user.email, subject: 'Your KYC Has Been Approved')
  end

  def kyc_rejected_notification(user, reason)
    @user = user
    @reason = reason
    mail(to: @user.email, subject: 'KYC Rejection Notice')
  end

  def deposit_confirmation(user, deposit)
    @user = user
    @deposit = deposit
    mail(to: @user.email, subject: "Deposit Confirmed - ₹#{@deposit.amount}")
  end

  def deposit_notification(user, deposit)
    @user = user
    @deposit = deposit
    mail(to: @user.email, subject: "Deposit Successful - ₹#{@deposit.amount}")
  end

  def withdrawal_initiated(user, withdrawal)
    @user = user
    @withdrawal = withdrawal
    mail(to: @user.email, subject: "Withdrawal Initiated - #{@withdrawal.amount} #{@withdrawal.wallet.currency.code}")
  end

  def withdrawal_completed(user, withdrawal)
    @user = user
    @withdrawal = withdrawal
    mail(to: @user.email, subject: "Withdrawal Completed - #{@withdrawal.amount} #{@withdrawal.wallet.currency.code}")
  end

  def withdrawal_rejected(user, withdrawal, reason)
    @user = user
    @withdrawal = withdrawal
    @reason = reason
    mail(to: @user.email, subject: "Withdrawal Rejected - #{@withdrawal.amount} #{@withdrawal.wallet.currency.code}")
  end

  def trade_notification(user, trade)
    @user = user
    @trade = trade
    subject = "#{@trade.trade_type.titleize} Order Executed - #{@trade.trading_pair.pair_name}"
    mail(to: @user.email, subject: subject)
  end

  def password_changed_notification(user)
    @user = user
    mail(to: @user.email, subject: 'Password Changed Successfully')
  end
end
