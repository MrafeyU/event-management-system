class Admin::DashboardController < ApplicationController
  def index
    @users_count = User.count
    @events_count = Event.count
    @bookings_count = Booking.count
  end
end