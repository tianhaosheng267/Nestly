
class UpdateProperties < ActiveRecord::Migration[8.1]
  def change

remove_column :properties, :boolean, :string
remove_column :properties, :text, :string

columns = [:address, :city, :state, :zip, :landlord_id, :monthly_rent, :num_bedrooms, :num_bathrooms]
columns.each {|column|  change_column_null :properties, column, false }
  end
end
