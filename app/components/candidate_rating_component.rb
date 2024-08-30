# frozen_string_literal: true

# app/components/candidate_rating_component.rb
class CandidateRatingComponent < ViewComponent::Base
  def initialize(assessment_participation:)
    @assessment_participation = assessment_participation
  end
end
