class Candidate::AssessmentParticipationsController < ApplicationController
  before_action :authenticate_candidate!
  before_action :hide_navbar, except: %i[show index]
  before_action :setup_assessment_context, except: %i[index invitation]
  before_action :redirect_completed_assessment, only: %i[overview setup checkout]

  def index
    @assessment_participations = current_candidate.assessment_participations.order(created_at: :desc)
  end

  def show; end

  def invitation
    @assessment_participation = AssessmentParticipation.find_by!(invitation_token: params[:token])
    redirect_to overview_candidate_assessment_participation_path(@assessment_participation)
  end

  def overview
    @participation_service.invitataion_clicked
  end

  def setup
    @next_url = @participation_service.start
  end

  def checkout
    @next_url = @participation_service.complete
  end

  private

  def setup_assessment_context
    @assessment_participation = AssessmentParticipation.find(params[:hashid])
    @assessment = @assessment_participation.assessment
    @participation_service = AssessmentParticipationService.new(@assessment_participation)
    session[:participants] = {
      assessment_participation_id: @assessment_participation.id
    }
  end

  def redirect_completed_assessment
    return unless @assessment_participation.completed?

    redirect_to candidate_assessment_participation_path(@assessment_participation)
  end
end
