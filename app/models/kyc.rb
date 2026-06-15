class KYC < ApplicationRecord
  belongs_to :user
  has_one_attached :aadhaar_document
  has_one_attached :pan_document
  has_one_attached :selfie_document

  enum status: { nil: nil, pending: 1, approved: 2, rejected: 3 }

  validates :status, inclusion: { in: statuses.keys }
  validates :aadhaar_document, :pan_document, :selfie_document, presence: true

  before_create :set_pending_status
  after_update :send_kyc_notification

  scope :pending, -> { where(status: :pending) }
  scope :approved, -> { where(status: :approved) }

  private

  def set_pending_status
    self.status ||= :pending
  end

  def send_kyc_notification
    if saved_change_to_attribute?(:status)
      UserMailer.kyc_status_notification(user, status).deliver_later
    end
  end
end
