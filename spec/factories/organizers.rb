FactoryBot.define do
  factory :organizer, class: "Organizer" do
    name { "Test Organizer" }
    sequence(:email) { |n| "organizer#{n}@example.com"}
    password { "password123" }
  end
end