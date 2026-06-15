class CreateCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_table :currencies do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.boolean :is_crypto, default: false
      t.string :logo_url
      t.timestamps
    end
    add_index :currencies, :code, unique: true
  end
end
