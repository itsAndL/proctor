class Candidate::AssessmentParticipationsController < ApplicationController
  before_action :set_assessment_participation, only: [:show]

  def index
    @assessment_participations = current_candidate.assessment_participations
  end

  def show

  end

  def set_assessment_participation
    @assessment_participation = AssessmentParticipation.find_by_hashid(params[:hashid])
  end

end
