class CreateProperties < ActiveRecord::Migration[8.1]
  def change
    create_table :properties do |t|
      t.string :address
      t.string :text
      t.integer :zip
      t.text :city
      t.text :state
      t.integer :landlord_id
      t.decimal :monthly_rent
      t.date :date_available
      t.decimal :sqft
      t.integer :num_bedrooms
      t.integer :num_bathrooms
      t.string :pet_friendly
      t.string :boolean
      t.text :amenities

      t.timestamps
    end
  end
end
