require 'rails_helper'

RSpec.describe Event, type: :model do
 it "must have a date ahead of today" do
  # Create a minimal organizer for the event
  organizer = User.create!(name: "Test Organizer", email: "org@example.com", password: "password", type: "Organizer")

  event = Event.create!(
    title: "Test Event",
    description: "Some description",
    location: "Test Location",
    event_date: 0.days.from_now,
    total_seats: 100,
    seats_booked: 0,
    economy_seat_price: 20,
    standard_seat_price: 50,
    vip_seat_price: 100,
    organizer: organizer
  )

  expect(event.event_date).to be > Date.today
end

end
