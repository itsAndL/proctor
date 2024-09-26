class ApplicationPolicy < ActionPolicy::Base
  def index?
    false
  end

  def show?
    false
  end

  def new?
    create?
  end

  def create?
    false
  end

  def edit?
    update?
  end

  def update?
    false
  end

  def destroy?
    false
  end

  private

  def business_owner?
    user.business? && user.business.id == record.business_id
  end
end
