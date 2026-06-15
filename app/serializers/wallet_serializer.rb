class WalletSerializer < ActiveModel::Serializer
  attributes :id, :balance, :currency_code

  belongs_to :user
  belongs_to :currency

  def currency_code
    object.currency.code
  end
end
