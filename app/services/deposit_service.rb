class DepositService
  def initialize(user)
    @user = user
  end

  def create_razorpay_order(amount)
    raise "Amount must be greater than 0" if amount <= 0
    raise "KYC must be approved" unless kyc_approved?

    razorpay_order = create_razorpay_payment_order(amount)
    deposit = @user.deposits.create!(
      wallet: inr_wallet,
      amount: amount,
      razorpay_order_id: razorpay_order['id'],
      status: :pending
    )
    { deposit_id: deposit.id, razorpay_order: razorpay_order }
  end

  def confirm_deposit(deposit_id, razorpay_payment_id, razorpay_signature)
    deposit = @user.deposits.find(deposit_id)
    raise "Invalid deposit" unless deposit

    if verify_razorpay_signature(deposit.razorpay_order_id, razorpay_payment_id, razorpay_signature)
      ActiveRecord::Base.transaction do
        deposit.update!(status: :completed, razorpay_payment_id: razorpay_payment_id)
        inr_wallet.credit(deposit.amount, "INR Deposit via Razorpay - Order: #{deposit.razorpay_order_id}")
      end
      UserMailer.deposit_confirmation(@user, deposit).deliver_later
      true
    else
      deposit.update!(status: :failed)
      false
    end
  end

  private

  def inr_wallet
    @inr_wallet ||= @user.wallets.joins(:currency).find_by(currencies: { code: 'INR' })
  end

  def kyc_approved?
    @user.kyc&.approved?
  end

  def create_razorpay_payment_order(amount)
    client = Razorpay::Client.new(key_id: ENV['RAZORPAY_KEY_ID'], key_secret: ENV['RAZORPAY_KEY_SECRET'])
    client.order.create(amount: (amount * 100).to_i, currency: 'INR', receipt: "order_#{@user.id}_#{Time.current.to_i}")
  end

  def verify_razorpay_signature(order_id, payment_id, signature)
    client = Razorpay::Client.new(key_id: ENV['RAZORPAY_KEY_ID'], key_secret: ENV['RAZORPAY_KEY_SECRET'])
    body = "#{order_id}|#{payment_id}"
    expected_signature = OpenSSL::HMAC.hexdigest('SHA256', ENV['RAZORPAY_KEY_SECRET'], body)
    expected_signature == signature
  end
end
