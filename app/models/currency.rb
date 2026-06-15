class Currency < ApplicationRecord
  has_many :wallets, dependent: :destroy
  has_many :crypto_prices, dependent: :destroy
  has_many :trading_pairs_as_base, class_name: 'TradingPair', foreign_key: 'base_currency_id', dependent: :destroy
  has_many :trading_pairs_as_quote, class_name: 'TradingPair', foreign_key: 'quote_currency_id', dependent: :destroy

  validates :code, presence: true, uniqueness: true, length: { minimum: 3, maximum: 10 }
  validates :name, presence: true
  validates :is_crypto, inclusion: { in: [true, false] }

  scope :crypto, -> { where(is_crypto: true) }
  scope :fiat, -> { where(is_crypto: false) }

  def symbol
    code
  end
end
