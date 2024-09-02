class Candidate::AssessmentParticipationsController < ApplicationController
  before_action :set_assessment_participation, only: [:show, :overview, :setup, :intro]
  before_action :hide_navbar, only: [:overview, :setup, :intro]

  def index
    @assessment_participations = current_candidate.assessment_participations
  end

  def show; end

  def overview; end
  def setup; end
  def intro; end

  private

  def set_assessment_participation
    @assessment_participation = AssessmentParticipation.find_by_hashid(params[:hashid])
  end
end
