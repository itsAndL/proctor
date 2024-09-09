class Candidate::TestsController < ApplicationController
  before_action :authenticate_candidate!
  before_action :hide_navbar
  before_action :set_participation_test_service, except: %i[feedback]

  def show
    if @current_test.preview_questions.any?
      redirect_to intro_candidate_test_path(@current_test.hashid)
    else
      redirect_to start_candidate_test_path(@current_test.hashid)
    end
  end

  def start
    @test_service.start_test(@current_test)
  end

  def intro
    @test_service.start_practice_test(@current_test)
  end

  def feedback
    @participation_progress = ParticipationProgressService.new(session)
    @assessment_participation = @participation_progress.assessment_participation
    @current_test = @participation_progress.test
    @next_test = @assessment_participation.unanswered_tests.first
    if @next_test.present?
      @next_url = candidate_test_path(@next_test.hashid)
    else
      # For now, we gone skip the custom questions
      @next_url = checkout_candidate_assessment_participation_path(@assessment_participation.hashid)
    end
  end

  def questions
    @test_service.start_question
    render QuestionAnsweringFormComponent.new(
      session_service: @participation_progress,
      save_answer_path: save_answer_candidate_test_path(@current_test.hashid),
    )
  end

  def practice_questions
    @test_service.start_question
    render QuestionAnsweringFormComponent.new(
      session_service: @participation_progress,
      save_answer_path: save_answer_candidate_test_path(@current_test.hashid),
    )
  end

  def save_answer
    if !@test_service.preview
      selected_options_ids = if params[:selected_options].is_a?(Array)
          params[:selected_options]
        else
          raise "Invalid selected options"
        end
    end
    @test_service.save_answer(selected_options_ids)
    @test_service.next_question
    if @test_service.has_more_questions?
      render turbo_stream: turbo_stream.replace("question-form", QuestionAnsweringFormComponent.new(
        session_service: @participation_progress,
        save_answer_path: save_answer_candidate_test_path(@current_test.hashid),
      ))
    elsif @test_service.preview
      redirect_to start_candidate_test_path(@current_test.hashid)
    else
      redirect_to feedback_candidate_test_path(@current_test.hashid)
    end
  end

  private

  def save_answer_params
    params.require(:selected_options)
  end

  def set_participation_test_service
    @participation_progress = ParticipationProgressService.new(session)
    @assessment_participation = @participation_progress.assessment_participation
    @current_test = @assessment_participation.unanswered_tests.find_by_hashid(params[:hashid])
    @test_service = ParticipationTestService.new(session, @current_test)
  end
end
