
class FixPetFriendlyFieldProperties < ActiveRecord::Migration[8.1]
  def change
    change_column :properties, :pet_friendly, :boolean
    change_column_default :properties, :pet_friendly, from: nil, to: false
  end
end
