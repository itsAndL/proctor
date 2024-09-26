class TestPolicy < ApplicationPolicy
  def index?
    user.business?
  end

  def show?
    !record.business.present? || owner?
  end

  private

  def owner?
    user.business? && record.business == user.business
  end
end
