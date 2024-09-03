# frozen_string_literal: true

class ParticipationHeaderComponent < ViewComponent::Base
  def initialize(participation:)
    @participation = participation
    @assessment = participation.assessment
    @company = @assessment.company
  end
end
