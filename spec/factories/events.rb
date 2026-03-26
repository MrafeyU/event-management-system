FactoryBot.define do
  factory :event do
    title { "Test Event" }
    description { "Sample description" }
    location { "Test Location" }
    event_date { 3.days.from_now }
    total_seats { 100 }
    seats_booked { 0 }
    economy_seat_price { 20 }
    standard_seat_price { 50 }
    vip_seat_price { 100 }
    association :organizer, factory: :organizer
  end
end