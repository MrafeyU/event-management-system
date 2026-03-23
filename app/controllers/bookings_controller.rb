class BookingsController < ApplicationController
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
    success = false
    
    @event.with_lock do
      available_seats = @event.total_seats.to_i - @event.seats_booked.to_i
      
      if available_seats >= @booking.seats_booked && @event.event_date >= Date.today
        
        price_per_seat =
          case @booking.seat_type
          when "vip"
            then @event.vip_seat_price
          when "standard"
            then @event.standard_seat_price
          else @event.economy_seat_price
          end
        total_price = price_per_seat * @booking.seats_booked

        @booking.price_per_seat = price_per_seat
        @booking.total_price = total_price

        @booking.save!

        @event.increment!(:seats_booked, @booking.seats_booked)
        @event.increment!(:revenue, )
      
        current_user.increment!(:total_bookings, @booking.seats_booked)
      
        success = true
      end
    end

    if success
      BookingMailer.booking_confirmed(@booking).deliver_later
      redirect_to booking_path(@booking), notice: "Booking successful!"
    else 
      if  @event.event_date >= Date.today
        redirect_to event_path(@event), alert: "Not enough seats available! "
      else
         redirect_to event_path(@event), alert: "Date of event has already passed! "
      end
    end  
   
    rescue ActiveRecord::RecordInvalid
      redirect_to @event, alert: "Booking failed!  #{@booking.errors.full_messages.to_sentence}"
  end


  def edit  
    @booking = Booking.find(params[:id])
     authorize @booking
  end


  def update
    @booking = Booking.find(params[:id])
    authorize @booking
    previous_status = @booking.status

    if previous_status == "cancelled" && booking_params[:status] == "confirmed"
      redirect_to booking_path(@booking), alert: "Cancelled bookings cannot be confirmed."
    return
    end
    if @booking.update(booking_params)
      if previous_status != "cancelled" && @booking.status == "cancelled"
        @booking.event.decrement!(:seats_booked, @booking.seats_booked)
        @booking.attendee.decrement!(:total_bookings, @booking.seats_booked)
      end
      redirect_to booking_path(@booking), notice: "Booking updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  
  def destroy
    # set booking to current booking
    @booking = Booking.find(params[:id])
    authorize @booking

    ActiveRecord::Base.transaction do
      @booking.event.decrement!(:seats_booked, @booking.seats_booked)
      @booking.attendee.decrement!(:total_bookings, @booking.seats_booked)

      @booking.destroy
    end
    @booking.destroy
    BookingMailer.booking_cancelled(@booking).deliver_later
    redirect_to bookings_path, notice: "Booking deleted successfully."
  end




  private 
    def booking_params
      params.expect(:booking => [:attendee_id, :status, :seats_booked, :seat_type])
    end
end
