class OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_type, :quantity, :price, :status, :remaining_quantity, :created_at, :updated_at

  belongs_to :user
  belongs_to :trading_pair
  has_many :trades

  def remaining_quantity
    object.remaining_quantity
  end
end
