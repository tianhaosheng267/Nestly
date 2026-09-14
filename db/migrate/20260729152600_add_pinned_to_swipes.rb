class AddPinnedToSwipes < ActiveRecord::Migration[8.1]
  def change
    add_column :swipes, :pinned, :boolean, default: false, null: false unless column_exists?(:swipes, :pinned)
  end
end