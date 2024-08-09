# frozen_string_literal: true

class CustomQuestionLibraryComponent < ViewComponent::Base
  def initialize(custom_questions:, clear_path:, assessment: nil)
    @custom_questions = custom_questions
    @clear_path = clear_path
    @assessment = assessment
    @library = :custom_question
  end

  def before_render
    @assessment ||= find_assessment_from_params if @assessment.nil?
  end

  def filters_applied?
    params[:search_query].present? ||
    params[:question_category].present? ||
    params[:question_type].present?
  end

  private

  def find_assessment_from_params
    Assessment.find(params[:assessment_id]) if params[:assessment_id]
  end
end
