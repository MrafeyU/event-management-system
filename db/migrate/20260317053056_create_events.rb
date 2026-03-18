class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.text :title
      t.text :description
      t.text :location
      t.datetime :event
      t.integer :total_seats
      t.integer :seats_booked
      t.integer :vip_seat_price
      t.integer :economy_seat_price
      t.integer :standard_seat_price
      t.references :user, null: false, foreign_key: true
      t.index ["title"], name: "index_events_on_title", unique: true

      t.timestamps
    end
  end
end
