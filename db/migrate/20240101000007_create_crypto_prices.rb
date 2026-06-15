class CreateCryptoPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :crypto_prices do |t|
      t.references :currency, null: false, foreign_key: true
      t.decimal :price, precision: 20, scale: 8, null: false
      t.decimal :market_cap, precision: 25, scale: 2
      t.decimal :volume_24h, precision: 25, scale: 2
      t.decimal :change_24h, precision: 10, scale: 4
      t.datetime :fetched_at, null: false
      t.timestamps
    end
    add_index :crypto_prices, [:currency_id, :fetched_at]
  end
end
