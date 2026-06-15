class TradingPair < ApplicationRecord
  belongs_to :base_currency, class_name: 'Currency', foreign_key: 'base_currency_id'
  belongs_to :quote_currency, class_name: 'Currency', foreign_key: 'quote_currency_id'
  has_many :orders, dependent: :destroy
  has_many :trades, dependent: :destroy

  validates :base_currency_id, uniqueness: { scope: :quote_currency_id }
  validates :is_active, inclusion: { in: [true, false] }

  scope :active, -> { where(is_active: true) }
  scope :by_pair, ->(base, quote) { joins(:base_currency, :quote_currency).where(currencies: { code: [base, quote] }) }

  def pair_name
    "#{base_currency.code}/#{quote_currency.code}"
  end
end
