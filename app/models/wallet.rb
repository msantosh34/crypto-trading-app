class Wallet < ApplicationRecord
  belongs_to :user
  belongs_to :currency
  has_many :wallet_ledgers, dependent: :destroy

  validates :user_id, uniqueness: { scope: :currency_id }
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  scope :by_currency, ->(code) { joins(:currency).where(currencies: { code: code }) }

  def credit(amount, description)
    lock!  # Pessimistic locking
    new_balance = balance + amount
    update!(balance: new_balance)
    wallet_ledgers.create!(
      transaction_type: :credit,
      amount: amount,
      balance_after: new_balance,
      description: description
    )
    new_balance
  end

  def debit(amount, description)
    lock!  # Pessimistic locking
    raise "Insufficient balance" if balance < amount
    new_balance = balance - amount
    update!(balance: new_balance)
    wallet_ledgers.create!(
      transaction_type: :debit,
      amount: amount,
      balance_after: new_balance,
      description: description
    )
    new_balance
  end
end
