class BookingsController < ApplicationController
  def index
    @bookings = Booking.all.order(created_at: :desc).includes(:attendee, :event)  
  end

  def show  
    @booking = Booking.find(params[:id])
  end

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    if @booking.save
      redirect_to booking_path(@booking), notice: "Booking created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit  
    @booking = Booking.find(params[:id])
  end

  def update    
    @booking = Booking.find(params[:id])
    if @booking.update(booking_params)
      redirect_to booking_path(@booking), notice: "Booking updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to bookings_path, notice: "Booking deleted successfully."
  end

  private 
  def booking_params
    params.require(:booking).permit(:user_id, :event_id, :status, :seats_booked)
  end
end
