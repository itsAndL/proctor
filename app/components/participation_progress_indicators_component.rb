# frozen_string_literal: true

class ParticipationProgressIndicatorsComponent < ViewComponent::Base
  def initialize(duration_left:, answered_count:, questions_count:)
    super
    @duration_left = duration_left
    @answered_count = answered_count
    @questions_count = questions_count
  end
end
