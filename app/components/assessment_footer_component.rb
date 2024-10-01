# frozen_string_literal: true

class AssessmentFooterComponent < ViewComponent::Base
  def initialize(assessment:, current_step:)
    @assessment = assessment
    @current_step = current_step
  end

  private

  def back_link
    case @current_step
    when 'choose_tests'
      edit_assessment_path(@assessment)
    when 'add_questions'
      choose_tests_assessment_path(@assessment)
    when 'finalize'
      add_questions_assessment_path(@assessment)
    end
  end

  def next_button_text
    @current_step == 'finalize' ? t('.finish') : t('.next')
  end

  def show_back_button?
    @current_step != 'new' && @current_step != 'edit'
  end
end
