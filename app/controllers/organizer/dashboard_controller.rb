class Organizer::DashboardController < ApplicationController
  def index
    @events = current_user.events
    @total_bookings = Booking.joins(:event)
                             .where(events: { organizer_id: current_user.id })
                             .count
  end

end
