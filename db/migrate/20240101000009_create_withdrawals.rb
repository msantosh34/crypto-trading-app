class CreateWithdrawals < ActiveRecord::Migration[7.0]
  def change
    create_table :withdrawals do |t|
      t.references :user, null: false, foreign_key: true
      t.references :wallet, null: false, foreign_key: true
      t.decimal :amount, precision: 20, scale: 8, null: false
      t.integer :status, default: 0
      t.string :wallet_address, null: false
      t.string :blockchain_transaction_hash
      t.text :rejection_reason
      t.timestamps
    end
    add_index :withdrawals, [:user_id, :created_at]
  end
end
