class ChangeStatusDetailsInBookings < ActiveRecord::Migration[8.1]
  def change
    change_column :bookings, :status, :string
  end
end
