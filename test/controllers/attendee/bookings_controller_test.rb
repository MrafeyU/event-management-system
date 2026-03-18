require "test_helper"

class Attendee::BookingsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get attendee_bookings_create_url
    assert_response :success
  end

  test "should get destroy" do
    get attendee_bookings_destroy_url
    assert_response :success
  end
end
