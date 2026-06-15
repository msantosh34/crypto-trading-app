class Trade < ApplicationRecord
  belongs_to :user
  belongs_to :order
  belongs_to :trading_pair
  has_many :wallet_ledgers, dependent: :nullify

  enum trade_type: { buy: 1, sell: 2 }
  enum status: { pending: 1, completed: 2, failed: 3 }

  validates :quantity, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than: 0 }

  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user) { where(user: user) }
  scope :completed, -> { where(status: :completed) }

  def total_amount
    quantity * price
  end

  after_create :send_trade_notification

  private

  def send_trade_notification
    UserMailer.trade_notification(user, self).deliver_later if status == 'completed'
  end
end
