# frozen_string_literal: true

class AssessmentTitleComponent < ViewComponent::Base
  def initialize(assessment:, current_action:, rename: false)
    @assessment = assessment
    @current_action = current_action
    @rename = rename
  end

  def title
    @current_action == 'new' ? 'Untitled assessment' : @assessment.title
  end

  def tests_count
    count = @assessment.tests.count
    "#{count} #{count == 1 ? 'test' : 'tests'}"
  end
end
