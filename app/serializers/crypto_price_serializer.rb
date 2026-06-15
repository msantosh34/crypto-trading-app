class CryptoPriceSerializer < ActiveModel::Serializer
  attributes :id, :price, :market_cap, :volume_24h, :change_24h, :currency_code, :fetched_at

  belongs_to :currency

  def currency_code
    object.currency.code
  end
end
