class Candidate::CustomQuestionsController < ApplicationController
  include CustomQuestionParticipationConcern

  before_action :authenticate_candidate!
  before_action :hide_navbar
  before_action :set_assessment_participation
  before_action :set_current_custom_question, except: %i[show feedback]
  before_action :validate_save_answer_params, only: %i[save_answer]

  def show; end

  def feedback
    @current_custom_question = @assessment_participation.custom_questions.find(params[:hashid])
    @next_url = if @participation_service.more_custom_questions?
                  questions_candidate_custom_question_path(@participation_service.first_unanswered_custom_question)
                else
                  checkout_candidate_assessment_participation_path(@assessment_participation)
                end
  end

  def questions
    @participation_service.start_custom_question(@current_custom_question)

    render question_form_component
  end

  def save_answer
    @participation_service.create_custom_question_answer(@current_custom_question, params)
    redirect_to feedback_candidate_custom_question_path(@current_custom_question)
  end

  private

  def validate_save_answer_params
    params.require(:question_id)
  end

  def set_assessment_participation
    @assessment_participation = find_assessment_participation_from_session
    redirect_to candidate_assessment_participations_path unless @assessment_participation
    @participation_service = AssessmentParticipationService.new(@assessment_participation)
  end

  def set_current_custom_question
    @current_custom_question = @assessment_participation.unanswered_custom_questions.find(params[:hashid])
    if @current_custom_question.nil?
      if @participation_service.more_custom_questions?
        return redirect_to candidate_custom_question_path(first_unanswered_custom_question)
      end

      return redirect_to checkout_candidate_assessment_participation_path(@assessment_participation)
    end

    return if @current_custom_question

    redirect_to checkout_candidate_assessment_participation_path(@assessment_participation)
  end
end
