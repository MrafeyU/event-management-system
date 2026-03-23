class RenameColumnUserIdToAttendeeIdInBookings < ActiveRecord::Migration[8.1]
  def change
     rename_column :bookings, :user_id, :attendee_id
    add_foreign_key :bookings, :users, column: :attendee_id  
  end
end
