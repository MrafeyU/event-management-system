class Event < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :attendees, through: :bookings
  belongs_to :organizer
  has_many_attached :images
  validate :date_cannot_be_in_the_past
  before_validation :set_minimum_seats_booked
  scope :by_date, ->(date) { where("DATE(event_date) = ?", date) }
  scope :search, ->(query){where("title ILIKE ?", "%#{query}%")}

  private
  def set_minimum_seats_booked
    self.seats_booked = [self.seats_booked, 0].max if self.seats_booked.present?
  end

  def date_cannot_be_in_the_past
    if event_date.present? && event_date < Date.today
      errors.add(:event_date, "can't be in the past")
    end
  end
end
