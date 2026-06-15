class TradingPairSerializer < ActiveModel::Serializer
  attributes :id, :pair_name, :is_active

  belongs_to :base_currency
  belongs_to :quote_currency

  def pair_name
    object.pair_name
  end
end
