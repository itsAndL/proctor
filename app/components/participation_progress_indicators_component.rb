# frozen_string_literal: true

class ParticipationProgressIndicatorsComponent < ViewComponent::Base
  def initialize(duration:, duration_left:, answered_count:, questions_count:, custom_question: false)
    super
    @duration = duration
    @duration_left = duration_left
    @answered_count = answered_count
    @questions_count = questions_count
    @custom_question = custom_question
  end

  def infinite_time
    @duration.zero? || @duration_left.negative?
  end
end
