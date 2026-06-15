class CryptoPrice < ApplicationRecord
  belongs_to :currency

  validates :price, numericality: { greater_than: 0 }
  validates :currency_id, uniqueness: { scope: :fetched_at }

  scope :latest, -> { order(fetched_at: :desc).limit(1) }
  scope :for_currency, ->(code) { joins(:currency).where(currencies: { code: code }) }
  scope :recent, ->(hours = 24) { where('fetched_at > ?', hours.hours.ago) }

  def self.current_price(currency_code)
    for_currency(currency_code).latest.first&.price
  end
end
