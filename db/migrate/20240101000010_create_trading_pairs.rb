class CreateTradingPairs < ActiveRecord::Migration[7.0]
  def change
    create_table :trading_pairs do |t|
      t.references :base_currency, null: false, foreign_key: { to_table: :currencies }
      t.references :quote_currency, null: false, foreign_key: { to_table: :currencies }
      t.boolean :is_active, default: true
      t.timestamps
    end
    add_index :trading_pairs, [:base_currency_id, :quote_currency_id], unique: true
  end
end
