class EventPolicy < ApplicationPolicy
  def index?
  end

  def show?
    true
  end

  def new?
    create?
  end

  def create?
    user.present? &&  user.is_a?(Organizer) || admin?
  end

  def edit?
    update?
  end

  def update?
    organizer? || admin?
  end

  def destroy?
    organizer? || admin?
  end 

  def remove_images?
    organizer? || admin?
  end 

  private
    def organizer?
      user.present? &&  user.is_a?(Organizer) && (record.organizer_id == user.id)
    end

    def admin?
      user.present? && user.is_a?(Admin)
    end


  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if user.is_a?(Admin)
        scope.all
      elsif user.is_a?(Organizer)
        scope.where(organizer_id: user.id)
      else
        scope.all
      end
    end
  end
end
