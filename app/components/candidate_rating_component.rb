# frozen_string_literal: true

class CandidateRatingComponent < ViewComponent::Base
  def initialize(assessment_participation:)
    @assessment_participation = assessment_participation
  end

  def render?
    true if @assessment_participation.started? || @assessment_participation.completed?
  end
end
