require "test_helper"

class Attendee::EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get attendee_events_index_url
    assert_response :success
  end

  test "should get show" do
    get attendee_events_show_url
    assert_response :success
  end
end
