require "test_helper"

class Admin::BookingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_bookings_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_bookings_show_url
    assert_response :success
  end

  test "should get new" do
    get admin_bookings_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_bookings_create_url
    assert_response :success
  end

  test "should get edit" do
    get admin_bookings_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_bookings_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_bookings_destroy_url
    assert_response :success
  end
end
