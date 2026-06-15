class WithdrawalSerializer < ActiveModel::Serializer
  attributes :id, :amount, :status, :wallet_address, :blockchain_transaction_hash, :rejection_reason, :created_at, :updated_at

  belongs_to :user
  belongs_to :wallet
end
