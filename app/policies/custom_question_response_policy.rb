class CustomQuestionResponsePolicy < ApplicationPolicy
  def update?
    owner?
  end

  def download?
    owner?
  end

  private

  def owner?
    user.business? && record.assessment_participation.assessment.business == user.business
  end
end
