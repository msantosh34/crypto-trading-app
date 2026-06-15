class TradeSerializer < ActiveModel::Serializer
  attributes :id, :trade_type, :quantity, :price, :status, :total_amount, :created_at, :updated_at

  belongs_to :user
  belongs_to :order
  belongs_to :trading_pair

  def total_amount
    object.quantity * object.price
  end
end
