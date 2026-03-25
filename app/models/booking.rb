class Booking < ApplicationRecord
  include AASM

  
  # defining an aasm column status. 
  aasm column: :status do
    state :confirmed, initial: true
    state :cancelled

    event :cancel do
      transitions from: :confirmed, to: :cancelled
      after do
        rollback_counters
        send_cancellation_email
      end
    end
  end


  belongs_to :attendee
  belongs_to :event

  enum :seat_type, { economy: 0, standard: 1, vip: 2 }, instance_methods: false

  validates :seats_booked, numericality: { greater_than: 0 }
  validates :seat_type, presence: true

  before_validation :set_pricing
  validate :event_not_expired
  validate :enough_seats_availaible
  after_create :update_event_and_user
  
  before_destroy :rollback_counters

  after_commit :send_cancellation_email, on: :destroy


  private 

    # rolling back counters after the booking is deleted... 
    def rollback_counters
      return unless status_changed?(to: 'cancelled') || destroyed?
      
      event.decrement!(:seats_booked, seats_booked)
      event.decrement!(:revenue, total_price)
      attendee.decrement!(:total_bookings, seats_booked)
    end


    def send_cancellation_email
      BookingMailer.booking_cancelled(self).deliver_later
    end


    def set_pricing
      return unless event && seats_booked && seat_type

      self.price_per_seat =
      case seat_type
      when "vip"
      event.vip_seat_price
      when "standard"
      event.standard_seat_price
      else
      event.economy_seat_price
      end

      self.total_price = price_per_seat * seats_booked
    end


    def enough_seats_availaible
      return unless event
      available = event.total_seats.to_i - event.seats_booked.to_i 
      if seats_booked > available
        errors.add(:base, "Not enough seats availaible!")
      end
    end


    def event_not_expired
      if event.event_date < Date.today
        errors.add(:base, "Event Already occurred")
      end
    end


    def update_event_and_user
      event.increment!(:seats_booked, seats_booked)
      event.increment!(:revenue, total_price)
      attendee.increment!(:total_bookings, seats_booked)
    end

end
