class UserPolicy < ApplicationPolicy
  def index?
    false
  end

  def show?
    owns_profile?
  end

  def new?
    create?
  end

  def create?
    false
  end

  def update?
    owns_profile?
  end

  def edit?
    update?
  end

  relation_scope do |relation|
    relation.where(id: user.id)
  end

  private

  def owns_profile?
    user.present? && user == record
  end
end
