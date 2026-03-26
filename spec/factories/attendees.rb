FactoryBot.define do
  factory :attendee, class: "Attendee" do
    name { "Test Attendee" }
    sequence(:email) { |n| "attendee#{n}@example.com" }
    password { "password123" }
  end
end