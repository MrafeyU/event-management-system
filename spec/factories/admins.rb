FactoryBot.define do
  factory :admin, class: "Admin" do
    name { "Test Admin" }
    sequence(:email) { |n| "admin#{n}@example.com" }
    password { "password123" }
  end
end
