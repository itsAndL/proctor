# frozen_string_literal: true

class CandidatesListComponent < ViewComponent::Base
  def initialize(assessment:, assessment_participations:, current_page:, total_items:, per_page:)
    @assessment = assessment
    @assessment_participations = assessment_participations
    @current_page = current_page
    @total_items = total_items
    @per_page = per_page
  end
end
