class Deposit < ApplicationRecord
  belongs_to :user
  belongs_to :wallet
  has_many :wallet_ledgers, dependent: :nullify

  enum status: { pending: 1, completed: 2, failed: 3 }

  validates :amount, numericality: { greater_than: 0 }
  validates :razorpay_payment_id, uniqueness: true, allow_nil: true

  scope :recent, -> { order(created_at: :desc) }
  scope :successful, -> { where(status: :completed) }

  after_update :send_deposit_notification

  private

  def send_deposit_notification
    if status_changed? && completed?
      UserMailer.deposit_notification(user, self).deliver_later
    end
  end
end
