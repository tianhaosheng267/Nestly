
class AddUserForeignKeys < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :properties, :users, column: :landlord_id
  end
end
