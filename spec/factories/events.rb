FactoryBot.define do
  # Event factory
  factory :event do
    # MUST use organizer factory
    association :organizer, factory: :organizer

    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    location { Faker::Address.full_address }
    event_date { Faker::Time.forward(days: 60, unit: :days) } # ensures date ahead of today
    total_seats { Faker::Number.between(from: 50, to: 500) }
    seats_booked { Faker::Number.between(from: 0, to: (total_seats * 0.5).to_i) }
    economy_seat_price { Faker::Number.between(from: 20, to: 50) }
    standard_seat_price { Faker::Number.between(from: 51, to: 100) }
    vip_seat_price { Faker::Number.between(from: 101, to: 200) }
    revenue { 0 }

    trait :full do
      seats_booked { total_seats }
    end

    trait :past do
      event_date { Faker::Time.backward(days: 60, unit: :days) }
    end
  end

  # User factory
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }

    factory :attendee do
      type { 'Attendee' } # default
    end

    factory :organizer do
      type { 'Organizer' } # MUST set type to Organizer for STI
    end
  end
end