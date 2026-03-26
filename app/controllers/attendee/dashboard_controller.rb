class Attendee::DashboardController < ApplicationController
  def index
    @bookings = current_user.bookings.includes(:event)
  end
end
