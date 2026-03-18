class Event < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :attendees, through: :bookings

  belongs_to :organizer
  has_many_attached :images


end
