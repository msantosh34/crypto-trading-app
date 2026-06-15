class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :phone_number, :date_of_birth, :created_at, :updated_at

  belongs_to :user
end
