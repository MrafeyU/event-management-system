class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :remove_images]
  
  def index
    @events = policy_scope(Event.all.order(created_at: :desc).includes(:organizer)).page(params[:page]).per(3)
    # date filter 
    if params[:date].present?
      @events = @events.by_date(params[:date])
    end
    if params[:query].present?
      @events = @events.search(params[:query])
    end
  end

  def show
    @bookings = policy_scope(@event.bookings).page(params[:page]).per(2)
    authorize @event
  end

  def new
    @event = Event.new
    authorize @event
  end

  def create
    @organizer = Organizer.find(event_params[:user_id])
    @event = @organizer.events.new(event_params.except(:user_id))
    authorize @event
    if @event.save
      redirect_to event_path(@event), notice: "Event created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @event
  end

  def update  
    authorize @event
    if @event.update(event_params.except(:user_id))
      redirect_to event_path(@event), notice: "Event updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def remove_images
    authorize @event
    attachment = @event.images.find(params[:attachment_id]) 
    attachment.purge
    redirect_back fallback_location: edit_event_path(@event), notice: 'Image removed'
  end

  def destroy
    authorize @event
    @event.destroy
    redirect_to events_path, notice: "Event deleted successfully."  
  end

  private 
  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.expect(event: [:title, :description, :location, :event_date, :total_seats, :user_id,
                          :vip_seat_price, :standard_seat_price, :economy_seat_price, images: []])
  end
end
