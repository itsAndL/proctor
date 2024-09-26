class AssessmentPolicy < ApplicationPolicy
  def index?
    user.business?
  end

  def create?
    user.business?
  end

  def show?
    owner?
  end

  def update?
    owner?
  end

  def archive?
    owner?
  end

  def unarchive?
    archive?
  end

  def require_edit?
    owner?
  end

  def choose_tests?
    owner?
  end

  def update_tests?
    owner?
  end

  def add_questions?
    owner?
  end

  def update_questions?
    owner?
  end

  def finalize?
    owner?
  end

  def finish?
    owner?
  end

  def rename?
    owner?
  end

  def update_title?
    owner?
  end

  relation_scope do |relation|
    relation.where(business: user.business)
  end

  private

  def owner?
    user.business? && record.business == user.business
  end
end
