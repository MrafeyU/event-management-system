class Organizer < User
  has_many :events, dependent: :destroy
end
