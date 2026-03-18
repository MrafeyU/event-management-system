require "test_helper"

class Organizer::EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get organizer_events_index_url
    assert_response :success
  end

  test "should get show" do
    get organizer_events_show_url
    assert_response :success
  end

  test "should get new" do
    get organizer_events_new_url
    assert_response :success
  end

  test "should get create" do
    get organizer_events_create_url
    assert_response :success
  end

  test "should get edit" do
    get organizer_events_edit_url
    assert_response :success
  end

  test "should get update" do
    get organizer_events_update_url
    assert_response :success
  end

  test "should get destroy" do
    get organizer_events_destroy_url
    assert_response :success
  end
end
