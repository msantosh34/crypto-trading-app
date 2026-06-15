class CreateKycs < ActiveRecord::Migration[7.0]
  def change
    create_table :kycs do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0
      t.datetime :approved_at
      t.datetime :rejected_at
      t.text :rejection_reason
      t.references :approved_by, foreign_key: { to_table: :users }
      t.references :rejected_by, foreign_key: { to_table: :users }
      t.timestamps
    end
    add_index :kycs, :user_id, unique: true
  end
end
