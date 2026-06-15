class CreateWalletLedgers < ActiveRecord::Migration[7.0]
  def change
    create_table :wallet_ledgers do |t|
      t.references :wallet, null: false, foreign_key: true
      t.integer :transaction_type, null: false
      t.decimal :amount, precision: 20, scale: 8, null: false
      t.decimal :balance_after, precision: 20, scale: 8, null: false
      t.string :description
      t.references :trade, foreign_key: true
      t.references :deposit, foreign_key: true
      t.references :withdrawal, foreign_key: true
      t.timestamps
    end
    add_index :wallet_ledgers, :created_at
  end
end
