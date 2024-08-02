# frozen_string_literal: true

class TestLibraryComponent < ViewComponent::Base
  attr_reader :tests, :clear_path, :assessment

  def initialize(tests:, clear_path:, assessment: nil)
    @tests = tests
    @clear_path = clear_path
    @assessment = assessment
  end

  def before_render
    @assessment ||= find_assessment_from_params if @assessment.nil?
  end

  private

  def find_assessment_from_params
    Assessment.find(params[:assessment_id]) if params[:assessment_id]
  end
end
