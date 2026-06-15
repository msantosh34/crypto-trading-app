class WalletLedger < ApplicationRecord
  belongs_to :wallet
  belongs_to :trade, optional: true
  belongs_to :deposit, optional: true
  belongs_to :withdrawal, optional: true

  enum transaction_type: { credit: 1, debit: 2 }

  validates :amount, numericality: { greater_than: 0 }
  validates :balance_after, numericality: { greater_than_or_equal_to: 0 }
  validates :transaction_type, presence: true

  scope :credits, -> { where(transaction_type: :credit) }
  scope :debits, -> { where(transaction_type: :debit) }
  scope :recent, -> { order(created_at: :desc) }
end
