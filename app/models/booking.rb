class Booking < ApplicationRecord
  belongs_to :attendee
  belongs_to :event
  enum :status,  { confirmed: 0, cancelled: 1 }
  enum :seat_type, { economy: 0, standard: 1, vip: 2 }


  validates :seats_booked, numericality: { greater_than: 0 }
  validates :seat_type, presence: true
end
