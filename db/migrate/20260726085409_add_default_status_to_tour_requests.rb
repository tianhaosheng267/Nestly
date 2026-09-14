class AddDefaultStatusToTourRequests < ActiveRecord::Migration[8.1]
  def change
    change_column_default :tour_requests,
                          :status,
                          from: nil,
                          to: "pending"
  end
end
