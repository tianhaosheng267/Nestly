

class RemoveRoleFromUsers < ActiveRecord::Migration[8.1]
  def up
    remove_column :users, :role, :string
  end

  def down
    add_column :users,
               :role,
               :string,
               null: false,
               default: "renter"
  end
end
