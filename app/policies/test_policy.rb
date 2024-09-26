class TestPolicy < ApplicationPolicy
  def index?
    user.business?
  end

  def show?
    !record.business.present? || owner? || participant?
  end

  def start?
    participant?
  end

  def intro?
    participant?
  end

  def feedback?
    participant?
  end

  def questions?
    participant?
  end

  def practice_questions?
    participant?
  end

  def save_answer?
    participant?
  end

  private

  def participant?
    user.candidate? && record.candidate == user.candidate
  end

  def owner?
    user.business? && record.business == user.business
  end
end
