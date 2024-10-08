# frozen_string_literal: true

class TestLibraryComponent < ViewComponent::Base
  attr_reader :tests, :clear_path, :assessment

  def initialize(tests:, clear_path:, assessment: nil, business: nil)
    @tests = tests
    @clear_path = clear_path
    @assessment = assessment
    @business = business
  end

  def before_render
    @assessment ||= find_assessment_from_params if @assessment.nil?
  end

  def filters_applied?
    params[:test_source].present? ||
      params[:search_query].present? ||
      params[:test_category].present? ||
      params[:test_type].present? ||
      params[:language].present? ||
      params[:test_duration].present?
  end

  private

  def find_assessment_from_params
    Assessment.find(params[:assessment_hashid]) if params[:assessment_hashid]
  end
end
