class Withdrawal < ApplicationRecord
  belongs_to :user
  belongs_to :wallet
  has_many :wallet_ledgers, dependent: :nullify

  enum status: { pending: 1, processing: 2, completed: 3, rejected: 4 }

  validates :amount, numericality: { greater_than: 0 }
  validates :wallet_address, presence: true, format: { with: /\A[a-zA-Z0-9]+\z/ }

  scope :recent, -> { order(created_at: :desc) }
  scope :pending_or_processing, -> { where(status: [:pending, :processing]) }

  before_create :validate_sufficient_balance
  after_update :send_withdrawal_notification

  private

  def validate_sufficient_balance
    errors.add(:amount, "Insufficient wallet balance") if wallet.balance < amount
  end

  def send_withdrawal_notification
    if status_changed?
      UserMailer.withdrawal_notification(user, self).deliver_later
    end
  end
end
