# frozen_string_literal: true

class AssessmentScoreCardComponent < ViewComponent::Base
  def initialize(assessment_participation:)
    @assessment_participation = assessment_participation
  end

  private

  attr_reader :assessment_participation

  def assessment
    assessment_participation.assessment
  end

  def invited_date
    helpers.human_date(assessment_participation.created_at)
  end

  def overall_score_percentage
    assessment_participation.evaluate_full_assessment.overall_score_percentage
  end

  def status
    assessment_participation.humanized_status
  end

  def tests_present?
    assessment.tests.any?
  end

  def assessment_in_progress?
    assessment_participation.started? || assessment_participation.completed?
  end
end
