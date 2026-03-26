class BookingPolicy < ApplicationPolicy

  def index?
    attendee? || admin? || organizers_event_booking?
  end

  def new?
    create?
  end

  def show?
    attendee? || admin? || organizers_event_booking?
  end

  def create?
     user.present? &&  user.is_a?(Attendee) || admin?
  end

  def cancel?
    attendee? || admin?
  end

  def destroy?
    attendee? || admin?
  end

  private
  def organizers_event_booking?
    user.present? &&  user.is_a?(Organizer) && record.event.organizer_id == user.id
  end

  def attendee?
    user.present? &&  user.is_a?(Attendee) && record.attendee_id == user.id
  end

  def admin?
    user.present? && user.is_a?(Admin)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.is_a?(Admin)
        scope.all
      elsif user.is_a?(Attendee)
        scope.where(attendee_id: user.id)
      elsif user.is_a?(Organizer)
         scope.joins(:event).where(events:{ organizer_id: user.id })
      else
          scope.none
      end
    end
  end
end
