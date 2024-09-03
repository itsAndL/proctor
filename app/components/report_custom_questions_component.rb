# frozen_string_literal: true

class ReportCustomQuestionsComponent < ViewComponent::Base
  def initialize(assessment_participation:)
    @assessment_participation = assessment_participation
  end

  def render?
    @assessment_participation.completed? && @assessment_participation.custom_question_responses.any?
  end
end
