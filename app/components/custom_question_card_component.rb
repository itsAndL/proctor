# frozen_string_literal: true

class CustomQuestionCardComponent < ViewComponent::Base
  def initialize(custom_question:, assessment: nil)
    @custom_question = custom_question
    @assessment = assessment
    @assessment_custom_question = find_assessment_custom_question if @assessment
  end

  private

  def find_assessment_custom_question
    @assessment.assessment_custom_questions.find_by(custom_question: @custom_question)
  end
end
