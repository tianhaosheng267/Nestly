
class UpdateAttributeTypesProperties < ActiveRecord::Migration[8.1]
  def change
    change_column :properties, :monthly_rent, :integer
  end
end
