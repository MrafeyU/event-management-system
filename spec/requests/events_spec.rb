require 'rails_helper'

RSpec.describe "Events", type: :request do
  let(:organizer) { create(:organizer) }
  let(:attendee) { create(:attendee) }
  let(:admin){create(:admin)}

  let!(:event) { create(:event, organizer: organizer) }
  let(:role) { "organizer" }  # can switch to "attendee" to test attendee routes

  before do
    # Sign in the user using Devise test helpers
    sign_in organizer
  end

  describe "GET /:role/events" do
    it "lists events" do
      get "/#{role}/events"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(event.title)
    end
  end
  
  describe "GET /:role/events/id" do
    it "selected event " do
      get "/#{role}/events/#{event.id}"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(event.title)
    end
  end

  describe "POST /:role/events" do
  it "creates an event" do
    expect {
      post events_path, role: role, params: {
        event: {
          title: "New Event",
          description: "Test desc",
          event_date: 2.days.from_now,
          total_seats: 50,
          organizer_id: organizer.id
        }
      }
    }
    end
  end
end
