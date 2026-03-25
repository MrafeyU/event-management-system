class BookingsController < ApplicationController
  before_action :set_booking, only: [:cancel]
# view all bookings 
  def index
    @bookings = policy_scope(Booking.all.order(created_at: :desc).includes(:attendee, :event))
  end

  def show 
    @booking = Booking.find(params[:id])
    authorize @booking
  end

  def new
    @event = Event.find(params[:event_id])
    @booking = Booking.new
  end

  def create
    @event = Event.find(params[:event_id])
    @booking = @event.bookings.build(booking_params)
    authorize @booking

    @event.with_lock do
      if @booking.save
        BookingMailer.booking_confirmed(@booking).deliver_later
        redirect_to booking_path(@booking), notice: "Booking successful!"
      else
        redirect_to event_path(@event),
          alert: @booking.errors.full_messages.to_sentence
      end
    end

    rescue ActiveRecord::RecordInvalid
      redirect_to @event, alert: "Booking failed! #{@booking.errors.full_messages.to_sentence}"
  end


  def cancel
    # Trigger the event
    if @booking.cancel!
      redirect_to @booking, notice: 'Booking was successfully cancelled.'
    else
      redirect_to @booking, alert: 'Booking could not be cancelled. ' + @booking.errors.full_messages.to_sentence
    end
  rescue AASM::InvalidTransition
    redirect_to @booking, alert: 'Invalid transition: Cannot cancel this booking.'
  end




  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking

    @booking.destroy

    redirect_to bookings_path, notice: "Booking deleted successfully."
  end





  private 
    def set_booking
      @booking = Booking.find(params[:id])
    end
    def booking_params
      params.expect(:booking => [:attendee_id, :seats_booked, :seat_type])
    end
end
