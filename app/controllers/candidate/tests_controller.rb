class Candidate::TestsController < ApplicationController
  include AssessmentFormConcern

  before_action :authenticate_candidate!
  before_action :hide_navbar
  before_action :setup_assessment_context
  before_action :redirect_completed_assessment, only: %i[intro practice_questions start questions feedback]
  before_action :set_current_test, except: %i[feedback]
  before_action :set_current_question, only: %i[save_answer]
  before_action :validate_save_answer_params, only: %i[save_answer]

  def show
    participation_test = @assessment_participation.participation_tests.find_by(test: @current_test)
    if @current_test.preview_questions.any? && participation_test.pending?
      redirect_to intro_candidate_test_path(@current_test)
    else
      redirect_to start_candidate_test_path(@current_test)
    end
  end

  def start; end

  def intro
    @current_question = @current_test.preview_questions.first
  end

  def feedback
    @current_test = @assessment_participation.tests.find(params[:hashid])
    @next_url = @participation_service.complete_test(@current_test)
  end

  def questions
    @participation_service.start_test(@current_test)
    @current_question = @participation_service.first_unanswered_question(@current_test)
    render question_form
  end

  def practice_questions
    @current_question = @current_test.preview_questions.find(params[:question_id])
    render question_form
  end

  def save_answer
    participation_test = @assessment_participation.participation_tests.find_by(test: @current_test)
    return redirect_to feedback_candidate_test_path(@current_test) if participation_test.completed?

    @current_question = @participation_service.create_question_answer(@current_test, @question, params)
    if @question.preview
      if @current_test.preview_questions.last != @question && @current_test.present?
        render turbo_stream: turbo_stream.replace('question-form', question_form)
      else
        redirect_to start_candidate_test_path(@current_test)
      end
    elsif @participation_service.more_questions?(@current_test) && @current_test.present?
      render turbo_stream: turbo_stream.replace('question-form', question_form)
    else
      redirect_to feedback_candidate_test_path(@current_test)
    end
  end

  private

  def validate_save_answer_params
    params.require(:question_id)
  end

  def setup_assessment_context
    @assessment_participation = find_assessment_participation_from_session
    redirect_to candidate_assessment_participations_path unless @assessment_participation
    @participation_service = AssessmentParticipationService.new(@assessment_participation)
  end

  def redirect_completed_assessment
    return unless @assessment_participation.completed?

    redirect_to candidate_assessment_participation_path(@assessment_participation)
  end

  def set_current_test
    @current_test = @assessment_participation.unanswered_tests.find(params[:hashid])
  rescue ActiveRecord::RecordNotFound
    if @participation_service.first_unanswered_test.present?
      redirect_to candidate_test_path(@participation_service.first_unanswered_test)
    elsif @participation_service.more_custom_questions?
      redirect_to start_candidate_custom_question_path(hashid: @participation_service.first_unanswered_custom_question)
    else
      redirect_to checkout_candidate_assessment_participation_path(@assessment_participation)
    end
  end

  def set_current_question
    question_id = params[:question_id]
    @question = Question.find(question_id)
  end
end
