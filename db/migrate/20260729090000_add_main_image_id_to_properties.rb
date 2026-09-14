
class AddMainImageIdToProperties < ActiveRecord::Migration[8.1]
  def change
    add_column :properties, :main_image_id, :integer
  end
end
