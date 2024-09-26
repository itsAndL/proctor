class CustomQuestionPolicy < ApplicationPolicy
  def index?
    user.business?
  end

  def start
    owner?
  end

  def questions
    owner?
  end

  def save_answer
    owner?
  end

  private

  def owner?
    user.candidate? && record.assessment_participation.candidate == user
  end
end
