# frozen_string_literal: true

class AssessmentResultsComponent < ViewComponent::Base
  def initialize(assessment_participation:)
    @assessment_participation = assessment_participation
  end

  private

  def overall_score
    @overall_score ||= @assessment_participation.evaluate_full_assessment.overall_score_percentage
  end

  def best_candidate_score
    @best_candidate_score ||= @assessment_participation.assessment.best_candidate_score
  end

  def candidate_pool_average
    @candidate_pool_average ||= @assessment_participation.assessment.candidate_pool_average
  end

  def test_results
    @test_results ||= @assessment_participation.evaluate_full_assessment.test_scores
  end
end
