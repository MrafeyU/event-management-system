require 'rails_helper'

RSpec.describe "Bookings", type: :request do
  let(:organizer) { create(:organizer) }
  let(:attendee) { create(:attendee) }
  let(:admin){ create(:admin) }

  let!(:event) { create(:event, organizer: organizer)}
  let!(:booking) { create(:booking, event: event, attendee: attendee)}
  let(:role) { "attendee" }

  before do
    # Sign in the user using Devise test helpers
    sign_in attendee
  end

  describe "GET /index" do
    it "fetch all the bookings" do
      get bookings_path(role: role) 
    end
  end

  describe "Get /show" do 
    it "Fetches a single booking" do 
     expect { 
        post bookings_path, role: role, booking: booking
      }
    end
  end
  
  describe "POST /create a new booking" do 
    it "creates a valid booking" do 
      expect { 
        post bookings_path, role: role, params: {
          booking: {
            attendee_id: attendee.id,
            seats_booked: 10,
            seat_type: "vip", 
            event: event
          }
        }
      }
    end
  end

  describe "PATCH /cancel a booking" do 
    it "update the event to status cancel" do
      expect { 
        patch cancel_booking_path, role: role, booking: booking
      }
    end
  end
end
