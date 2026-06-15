class CreateDeposits < ActiveRecord::Migration[7.0]
  def change
    create_table :deposits do |t|
      t.references :user, null: false, foreign_key: true
      t.references :wallet, null: false, foreign_key: true
      t.decimal :amount, precision: 20, scale: 8, null: false
      t.integer :status, default: 0
      t.string :razorpay_order_id
      t.string :razorpay_payment_id
      t.timestamps
    end
    add_index :deposits, :razorpay_payment_id, unique: true
    add_index :deposits, [:user_id, :created_at]
  end
end
