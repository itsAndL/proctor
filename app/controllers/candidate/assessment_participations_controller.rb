class Candidate::AssessmentParticipationsController < ApplicationController
  before_action :authenticate_user!
  before_action :hide_navbar, except: %i[show index]
  before_action :set_assessment_participation, except: %i[index]
  before_action :authorized_record, except: %i[index]

  def index
    authorize!
    query = AssessmentParticipationQuery.new(user: current_user)
    @assessment_participations = query.sorted
  end

  def show; end

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

  def set_assessment_participation
    @assessment_participation = AssessmentParticipation.find(params[:hashid])
    @assessment = @assessment_participation.assessment
    @participation_service = AssessmentParticipationService.new(@assessment_participation)
    session[:participants] = {
      assessment_participation_id: @assessment_participation.id
    }
  end

  def authorized_record
    authorize! @assessment_participation
  end
end
