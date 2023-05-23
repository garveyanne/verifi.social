class PostPolicy < ApplicationPolicy


  def show?
    true
  end

  def new?
    create?
  end

  def create?
   true
  end

  def update?
    record.user == user
  end

  def edit?
    update?
  end

  def destroy?
    record.user == user
  end

  def create?
    true
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
     def resolve
       user.admin? ? scope.all : scope.where(user: user)
     end

  end
end
