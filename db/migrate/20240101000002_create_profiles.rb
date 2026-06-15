class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :phone_number
      t.date :date_of_birth
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.timestamps
    end
    add_index :profiles, :phone_number, unique: true
  end
end
