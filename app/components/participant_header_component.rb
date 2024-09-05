# frozen_string_literal: true

class ParticipantHeaderComponent < ViewComponent::Base
  def initialize(participant:, back_path:, show_navigation: false, prev_path: nil, next_path: nil, current_index: nil, total_count: nil)
    @participant = participant
    @back_path = back_path
    @show_navigation = show_navigation
    @prev_path = prev_path
    @next_path = next_path
    @current_index = current_index
    @total_count = total_count
  end

  def avatarable
    @participant.is_a?(Candidate) ? @participant : Candidate.new
  end
end
