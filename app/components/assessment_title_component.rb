# frozen_string_literal: true

class AssessmentTitleComponent < ViewComponent::Base
  def initialize(assessment:, rename: false)
    @assessment = assessment
    @rename = rename
  end

  def title
    @assessment.title.present? ? @assessment.title : t('.untitled')
  end

  def tests_count
    @assessment.tests.count
  end

  def show_language
    @assessment.language.present?
  end
end
