class CustomQuestionPolicy < ApplicationPolicy
  def index?
    user.business?
  end

  def start
    participant?
  end

  def questions
    participant?
  end

  def save_answer
    participant?
  end

  def change_position?
    owner?
  end

  def destroy?
    owner?
  end

  def set_assessment?
    owner?
  end

  def set_item?
    owner?
  end

  def set_assessment_item?
    owner?
  end

  def respond_with_turbo_stream?
    owner?
  end

  def turbo_stream_updates?
    owner?
  end

  def render_header?
    owner?
  end

  def string_to_boolean?
    owner?
  end

  def association_name?
    owner?
  end

  def item_class?
    owner?
  end

  def item_param_key?
    owner?
  end

  def item_key?
    owner?
  end

  def item_name?
    owner?
  end

  def table_id?
    owner?
  end

  def render_table?
    owner?
  end

  def render_item_card?
    owner?
  end

  private

  def participant?
    user.candidate? && record.assessment_participation.candidate == user
  end

  def owner?
    user.business? && record.assessment_participation.business == user.business
  end
end
