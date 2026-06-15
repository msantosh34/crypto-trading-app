class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :aadhaar_document
  has_one_attached :pan_document
  has_one_attached :selfie_document

  validates :phone_number, presence: true, uniqueness: true, format: { with: /\A\d{10}\z/ }
  validates :date_of_birth, presence: true

  after_update :notify_kyc_update

  private

  def notify_kyc_update
    UserMailer.profile_update_notification(user).deliver_later if saved_change_to_attribute?(:phone_number)
  end
end
