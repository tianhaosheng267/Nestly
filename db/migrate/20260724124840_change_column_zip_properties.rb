

class ChangeColumnZipProperties < ActiveRecord::Migration[8.1]
  def change
    change_column :properties, :zip, :string
    change_column_default :properties, :pet_friendly, from: nil, to: false
  end
end
