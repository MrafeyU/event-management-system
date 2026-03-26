class Attendee < User
    has_many :bookings, dependent: :destroy
    has_many :events, through: :bookings
end
