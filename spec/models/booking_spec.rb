require 'rails_helper'

RSpec.describe Booking, type: :model do
  it "creates a valid booking" do
    booking = build(:booking)
    expect(booking).to be_valid
    puts "Event: #{booking.event.title}"
    puts "Attendee: #{booking.attendee.name} (#{booking.attendee.type})"
  end

  it "saves successfully" do
    booking = create(:booking)
    expect(booking.persisted?).to be true
  end

  describe "after_create callback" do
    it "updates event seats_booked, event revenue, and attendee total_bookings" do
      # Create the associated event and attendee first
      attendee = create(:attendee, total_bookings: 0)
      event = create(:event, seats_booked: 0, total_seats: 3, revenue: 0)

      # creating a booking...
      booking = create(:booking,
                       seats_booked: 3,
                       price_per_seat: 50,
                       total_price: 150,
                       attendee: attendee,
                       event: event)

      # Reload records to reflect changes made by callback..
      event.reload
      attendee.reload

      # Expectations
      expect(event.seats_booked).to eq(3)
      expect(event.revenue).to eq(150)
      expect(attendee.total_bookings).to eq(3)
    end
  end
end
