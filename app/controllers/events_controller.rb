class EventsController < ApplicationController
  
  def index
    @events = Event.all.order(created_at: :desc).includes(:organizer)
  end


  def show
    @event = Event.find(params[:id])
    @bookings = @event.bookings.includes(:attendee)   
  end


  def new
    @event = Event.new
  end


  def create
    @organizer = Organizer.find(event_params[:user_id])
    @event = @organizer.events.new(event_params.except(:user_id))
    if @event.save
      redirect_to event_path(@event), notice: "Event created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end


  def edit
    @event = Event.find(params[:id])

  end


  def update  
    @event = Event.find(params[:id])
    @organizer = Organizer.find(event_params[:user_id])
    if @event.update(event_params.except(:user_id))
      redirect_to event_path(@event), notice: "Event updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def remove_images
    @event = Event.find(params[:id])
    attachment = @event.images.find(params[:attachment_id])
    attachment.purge

    redirect_back fallback_location: edit_event_path(@event)
  end


  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, notice: "Event deleted successfully."  
  end


  private 
  def event_params
    params.expect(event: [:title, :description, :location, :event_date, :total_seats, :user_id,
                          :vip_seat_price, :standard_seat_price, :economy_seat_price, images: []])
  end
end
