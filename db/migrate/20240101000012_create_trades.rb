class CreateTrades < ActiveRecord::Migration[7.0]
  def change
    create_table :trades do |t|
      t.references :user, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.references :trading_pair, null: false, foreign_key: true
      t.integer :trade_type, null: false
      t.decimal :quantity, precision: 20, scale: 8, null: false
      t.decimal :price, precision: 20, scale: 8, null: false
      t.integer :status, default: 0
      t.timestamps
    end
    add_index :trades, [:user_id, :created_at]
  end
end
