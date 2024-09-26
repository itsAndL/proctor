class BusinessPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    owner?
  end

  private

  def owner?
    record.user == user
  end
end
