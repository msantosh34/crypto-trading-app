class CurrencySerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :is_crypto
end
