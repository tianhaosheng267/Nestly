class CreatePictures < ActiveRecord::Migration[8.1]
  def change
    create_table :pictures do |t|
      t.integer :property_id
      t.string :image_path
      t.string :caption

      t.timestamps
    end
  end
end
