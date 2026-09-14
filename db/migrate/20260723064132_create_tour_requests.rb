class CreateTourRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :tour_requests do |t|
      t.integer :user_id
      t.integer :property_id
      t.date :requested_date
      t.time :requested_time
      t.string :status
      t.text :message

      t.timestamps
    end
  end
end
