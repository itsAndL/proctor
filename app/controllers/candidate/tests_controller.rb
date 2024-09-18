class Candidate::TestsController < ApplicationController
  include TestParticipationConcern
  helper_method :question_form_component

  before_action :authenticate_candidate!
  before_action :hide_navbar
  before_action :set_assessment_participation
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
  end

  def practice_questions
    @current_question = @current_test.preview_questions.find(params[:question_id])
  end

  def save_answer
    participation_test = @assessment_participation.participation_tests.find_by(test: @current_test)
    return redirect_to feedback_candidate_test_path(@current_test) if participation_test.completed?

    @current_question = @participation_service.create_question_answer(@current_test, @question, params)
    if @question.preview
      if @current_test.preview_questions.last != @question && @current_test.present?
        render turbo_stream: turbo_stream.replace('question-form', question_form_component)
      else
        redirect_to start_candidate_test_path(@current_test)
      end
    elsif @participation_service.more_questions?(@current_test) && @current_test.present?
      render turbo_stream: turbo_stream.replace('question-form', question_form_component)
    else
      redirect_to feedback_candidate_test_path(@current_test)
    end
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

  def set_current_test
    @current_test = @assessment_participation.tests.find(params[:hashid])
    raise 'undefined behavior' if @current_test.nil?

    redirect_to checkout_candidate_assessment_participation_path(@assessment_participation) unless @current_test
  end

  def set_current_question
    question_id = params[:question_id]
    @question = Question.find(question_id)
  end
end
