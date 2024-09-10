class Candidate::AssessmentParticipationsController < ApplicationController
  before_action :authenticate_candidate!
  before_action :hide_navbar, except: %i[show index]
  before_action :set_assessment_participation, except: %i[index]

  def index
    @assessment_participations = current_candidate.assessment_participations
  end

  def show
  end

  def overview
    @assessment_participation.invitation_clicked! if @assessment_participation.invited?
  end

  def setup
    @assessment_participation.started! if @assessment_participation.invited? || @assessment_participation.invitation_clicked?
    session["participation_progress"] = {}
    session["participation_progress"]["current_assessment_participation_id"] = @assessment_participation.id
    @next_url = if @assessment_participation.unanswered_tests.any?
        candidate_test_path(@assessment_participation.unanswered_tests.first.hashid)
      elsif @assessment_participation.unanswered_custom_questions.any?
        candidate_custom_question_path(@assessment_participation.unanswered_custom_questions.first.hashid)
      else
        redirect_to checkout_candidate_assessment_participation_path(@assessment_participation.hashid)
      end
  end

  def checkout
    @assessment_participation.completed!
    @next_url = candidate_assessment_participations_path(@assessment_participation.hashid)
  end

  def set_assessment_participation
    @assessment_participation = AssessmentParticipation.find_by_hashid(params[:hashid])
    @assessment = @assessment_participation.assessment
  end
end
