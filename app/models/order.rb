class Order < ApplicationRecord
  belongs_to :user
  belongs_to :trading_pair
  has_many :trades, dependent: :destroy

  enum order_type: { buy: 1, sell: 2 }
  enum status: { pending: 1, partial: 2, filled: 3, cancelled: 4 }

  validates :quantity, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than: 0 }

  scope :active, -> { where(status: [:pending, :partial]) }
  scope :by_user, ->(user) { where(user: user) }

  def remaining_quantity
    quantity - trades.sum(:quantity)
  end

  def is_filled?
    remaining_quantity.zero?
  end
end
