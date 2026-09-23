class AddCommunitySearchAndEmail < ActiveRecord::Migration[8.1]
  def change
    create_table :apartment_communities do |t|
      t.string :external_id, null: false
      t.string :name, null: false
      t.string :address
      t.string :website
      t.string :contact_email
      t.string :phone
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.datetime :fetched_at, null: false
      t.timestamps
    end
    add_index :apartment_communities, :external_id, unique: true

    create_table :apartment_searches do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :zip_code, null: false
      t.integer :radius_miles, null: false
      t.json :community_ids, default: [], null: false
      t.float :latitude
      t.float :longitude
      t.boolean :truncated, default: false, null: false
      t.datetime :searched_at
      t.timestamps
    end

    create_table :community_swipes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :apartment_community, null: false, foreign_key: true
      t.string :direction, null: false
      t.boolean :pinned, default: false, null: false
      t.timestamps
    end
    add_index :community_swipes, [:user_id, :apartment_community_id], unique: true

    create_table :gmail_connections do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :email, null: false
      t.text :access_token
      t.text :refresh_token
      t.datetime :expires_at
      t.timestamps
    end

    create_table :email_conversations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :gmail_connection, null: false, foreign_key: true
      t.references :apartment_community, foreign_key: true
      t.references :property, foreign_key: true
      t.string :recipient, null: false
      t.string :subject, null: false
      t.string :gmail_thread_id
      t.timestamps
    end

    create_table :email_deliveries do |t|
      t.references :email_conversation, null: false, foreign_key: true
      t.string :request_token, null: false
      t.string :status, default: 'sending', null: false
      t.timestamps
    end
    add_index :email_deliveries, :request_token, unique: true
  end
end
