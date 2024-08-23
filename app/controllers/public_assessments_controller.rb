class PublicAssessmentsController < ApplicationController
  before_action :hide_navbar

  def show
    @assessment = Assessment.find_by!(public_link_token: params[:public_link_token])
    render :link_inactive unless @assessment.public_link_active?
  end

  def invite
    @assessment = Assessment.find(params[:hashid])
    email = params[:email]
    participant = find_or_create_participant(email)

    participation = AssessmentParticipation.find_or_create_by!(
      assessment: @assessment,
      candidate: participant.is_a?(Candidate) ? participant : nil,
      temp_candidate: participant.is_a?(TempCandidate) ? participant : nil
    ) do |p|
      p.status = :invited if p.new_record?
    end

    if participation.persisted?
      AssessmentMailer.invite_email(participation).deliver_now
      redirect_to public_assessment_path(@assessment.public_link_token), notice: "Invitation sent successfully!"
    else
      redirect_to public_assessment_path(@assessment.public_link_token), alert: "Failed to create invitation. #{participation.errors.full_messages.join(', ')}"
    end
  end

  private

  def find_or_create_participant(email)
    Candidate.joins(:user).find_by(users: { email: email }) ||
      TempCandidate.find_by(email: email) ||
      TempCandidate.create!(email: email)
  end
end
