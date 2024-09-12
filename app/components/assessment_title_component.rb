# frozen_string_literal: true

class AssessmentTitleComponent < ViewComponent::Base
  def initialize(assessment:, rename: false)
    @assessment = assessment
    @rename = rename
  end

  def title
    @assessment.title.present? ? @assessment.title : 'Untitled assessment'
  end

  def tests_count
    count = @assessment.tests.count
    "#{count} #{count == 1 ? 'test' : 'tests'}"
  end

  def show_language
    @assessment.language.present?
  end
end
