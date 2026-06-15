class KYCSerializer < ActiveModel::Serializer
  attributes :id, :status, :aadhaar_document, :pan_document, :selfie_document, :approved_at, :rejected_at, :rejection_reason, :created_at, :updated_at

  belongs_to :user
end
