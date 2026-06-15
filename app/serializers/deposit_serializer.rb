class DepositSerializer < ActiveModel::Serializer
  attributes :id, :amount, :status, :razorpay_order_id, :razorpay_payment_id, :created_at, :updated_at

  belongs_to :user
  belongs_to :wallet
end
