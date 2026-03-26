FactoryBot.define do
  factory :booking do
    seats_booked { 2 }
    seat_type { 1 } # 0=economy, 1=standard, 2=vip
    price_per_seat { 50 } 
    total_price { seats_booked * price_per_seat }
    status { "confirmed" }

    association :attendee, factory: :attendee
    association :event, factory: :event
  end
end