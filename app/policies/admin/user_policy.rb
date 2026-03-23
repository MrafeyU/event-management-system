class Admin::UserPolicy < ApplicationPolicy

  def index?
  end


  def show?
    admin?
  end


  def create?
    admin?
  end


  def new?
    create?
  end


  def edit?
    update?
  end


  def update?
    return false unless admin?
    # cannot edit another admin
    !record.is_a?(Admin)
  end


  def destroy?
    return false unless admin?
    # cannot delete another admin
    !record.is_a?(Admin)
  end

  def admin?
    user.present? && user.is_a?(Admin)
  end



  # Optional: Scope
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.is_a?(Admin)
        scope.all
      else
        scope.none
      end
    end
  end


end
