class AddSeatTypeAndPriceToBookings < ActiveRecord::Migration[8.1]
  def change
    add_column :bookings, :seat_type, :integer
    add_column :bookings, :price_per_seat, :integer
    add_column :bookings, :total_price, :integer
  end
end
