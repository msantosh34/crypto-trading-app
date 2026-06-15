class WalletLedgerSerializer < ActiveModel::Serializer
  attributes :id, :transaction_type, :amount, :balance_after, :description, :created_at

  belongs_to :wallet
end
