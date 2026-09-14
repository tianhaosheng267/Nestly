class CreateSwipes < ActiveRecord::Migration[8.1]
  def change
    create_table :swipes do |t|
      t.integer :user_id, null: false
      t.references :property, null: false, foreign_key: true
      t.string :direction, null: false

      t.timestamps
    end
    add_index :swipes, [:user_id, :property_id], unique: true
  end
end

