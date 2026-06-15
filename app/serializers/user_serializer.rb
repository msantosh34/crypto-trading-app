class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :role, :created_at, :updated_at

  has_one :profile
  has_one :kyc
  has_many :wallets
end
