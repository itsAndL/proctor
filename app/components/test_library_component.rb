# frozen_string_literal: true

class TestLibraryComponent < ViewComponent::Base
  def initialize(tests:, clear_path:, assessment: nil)
    @tests = tests
    @clear_path = clear_path
    @assessment = assessment
  end

  def for_new_assessment?
    @assessment.present?
  end
end
