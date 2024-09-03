class Candidate::AssessmentParticipationsController < ApplicationController
  before_action :authenticate_candidate!
  before_action :set_assessment_participation, only: [:show, :overview, :setup]
  before_action :hide_navbar, only: [:overview, :setup]

  def index
    @assessment_participations = current_candidate.assessment_participations
  end

  def show; end

  def overview; end
  def setup; end

  private

  def set_assessment_participation
    @assessment_participation = AssessmentParticipation.find_by_hashid(params[:hashid])
  end
end
