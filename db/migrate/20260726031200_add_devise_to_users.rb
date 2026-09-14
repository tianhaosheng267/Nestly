


class AddDeviseToUsers < ActiveRecord::Migration[8.1]
  def self.up
    change_table :users do |t|
      
      t.string :encrypted_password,
               null: false,
               default: ""

      
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      
      t.datetime :remember_created_at
    end

    
    
    change_column_null :users, :password_digest, true

    add_index :users,
              :reset_password_token,
              unique: true
  end

  def self.down
    remove_index :users, :reset_password_token

    remove_column :users, :remember_created_at
    remove_column :users, :reset_password_sent_at
    remove_column :users, :reset_password_token
    remove_column :users, :encrypted_password

    
    change_column_null :users,
                       :password_digest,
                       false,
                       ""
  end
end
