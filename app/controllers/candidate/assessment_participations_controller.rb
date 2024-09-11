class Candidate::AssessmentParticipationsController < ApplicationController
  include Candidate::AssessmentParticipationsHelper

  before_action :authenticate_candidate!
  before_action :hide_navbar, except: %i[show index]
  before_action :set_assessment_participation, except: %i[index]

  def index
    @assessment_participations = current_candidate.assessment_participations
  end

  def show; end

  def overview
    @assessment_participation.invitation_clicked! if @assessment_participation.invited?
  end

  def setup
    handle_setup_for_assessment_participation(@assessment_participation)
    @next_url = determine_next_url(@assessment_participation)
  end

  def checkout
    @assessment_participation.completed!
    @next_url = candidate_assessment_participations_path(@assessment_participation)
    redirect_to @next_url
  end

  private

  def set_assessment_participation
    @assessment_participation = AssessmentParticipation.find(params[:hashid])
    @assessment = @assessment_participation.assessment
  end
end
