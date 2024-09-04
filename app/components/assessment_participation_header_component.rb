# frozen_string_literal: true

class AssessmentParticipationHeaderComponent < ViewComponent::Base
  def initialize(assessment_participation:)
    @assessment_participation = assessment_participation
    @assessment = assessment_participation.assessment
    @participants = @assessment.assessment_participations.order(created_at: :desc)
  end

  def call
    render(EntityHeaderComponent.new(
      entity: @assessment_participation,
      back_path: assessment_path(@assessment),
      show_navigation: true,
      prev_path: prev_participant_path,
      next_path: next_participant_path,
      current_index: current_index,
      total_count: total_participants
    ))
  end

  private

  def total_participants
    @participants.count
  end

  def current_index
    @participants.index(@assessment_participation) + 1
  end

  def prev_participant_path
    return nil if current_index == 1
    report_assessment_participation_path(@participants[current_index - 2])
  end

  def next_participant_path
    return nil if current_index == total_participants
    report_assessment_participation_path(@participants[current_index])
  end
end
