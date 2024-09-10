class Candidate::TestsController < ApplicationController
  before_action :authenticate_candidate!
  before_action :hide_navbar
  before_action :set_assessment_participation
  before_action :set_participation_test_service, except: %i[feedback]

  def show
    if @current_test.preview_questions.any?
      redirect_to intro_candidate_test_path(@current_test.hashid)
    else
      redirect_to start_candidate_test_path(@current_test.hashid)
    end
  end

  def start
    begin
      @test_service.start_test(@current_test)
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error(e)
      redirect_to feedback_candidate_test_path(@current_test.hashid)
    end
  end

  def intro
    begin
      @test_service.start_practice_test(@current_test)
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error(e)
      redirect_to feedback_candidate_test_path(@current_test.hashid)
    end
  end

  def feedback
    begin
      @current_test = @assessment_participation.answered_tests.last
      redirect_to candidate_assessment_participations_path(@assessment_participation.id) unless @current_test
      @next_test = @assessment_participation.unanswered_tests.first
      @next_url = @next_test.present? ? candidate_test_path(@next_test.hashid) : checkout_candidate_assessment_participation_path(@assessment_participation.hashid)
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error(e)
      redirect_to candidate_assessment_participations_path(@assessment_participation.id)
    end
  end

  def questions
    begin
      @test_service.start_question
      render QuestionAnsweringFormComponent.new(
        business: @assessment_participation.assessment.business,
        passed_questions_count: @test_service.passed_questions_count,
        questions_count: @test_service.questions_count,
        question: @test_service.current_question,
        test: @current_test,
        is_preview: @test_service.preview,
        question_started_at: @test_service.question_started_at,
        save_answer_path: save_answer_candidate_test_path(@current_test.hashid),
      )
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error(e)
      redirect_to feedback_candidate_test_path(@current_test.hashid)
    end
  end

  def practice_questions
    begin
      if @test_service.preview
        @test_service.start_question_preview
        render QuestionAnsweringFormComponent.new(
          business: @assessment_participation.assessment.business,
          passed_questions_count: @test_service.passed_questions_count,
          questions_count: @test_service.questions_count,
          question: @test_service.current_question,
          test: @current_test,
          is_preview: @test_service.preview,
          question_started_at: @test_service.question_started_at,
          save_answer_path: save_answer_candidate_test_path(@current_test.hashid),
        )
      else
        redirect_to questions_candidate_test_path(@current_test.hashid)
      end
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error(e)
      redirect_to questions_candidate_test_path(@current_test.hashid)
    end
  end

  def save_answer
    begin
      if @test_service.preview
        @test_service.next_question
      elsif params[:selected_options].is_a?(Array)
        @test_service.save_answer(params[:selected_options], question: @test_service.current_question)
      else
        @test_service.save_answer([], question: @test_service.current_question)
      end

      if @test_service.has_more_questions?
        render turbo_stream: turbo_stream.replace("question-form", QuestionAnsweringFormComponent.new(
          business: @assessment_participation.assessment.business,
          passed_questions_count: @test_service.passed_questions_count,
          questions_count: @test_service.questions_count,
          question: @test_service.current_question,
          test: @current_test,
          is_preview: @test_service.preview,
          question_started_at: @test_service.question_started_at,
          save_answer_path: save_answer_candidate_test_path(@current_test.hashid),
        ))
      elsif @test_service.preview
        redirect_to start_candidate_test_path(@current_test.hashid)
      else
        redirect_to feedback_candidate_test_path(@current_test.hashid)
      end
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error(e)
      redirect_to feedback_candidate_test_path(@current_test.hashid), alert: "Question not found."
    end
  end

  private

  def save_answer_params
    params.require(:selected_options)
  end

  def set_participation_test_service
    set_assessment_participation
    set_current_test
    set_test_service
  end

  def set_assessment_participation
    participation_id = session["participation_progress"]["current_assessment_participation_id"]
    redirect_to candidate_assessment_participations_path unless participation_id
    @assessment_participation = AssessmentParticipation.find(participation_id)
  end

  def set_current_test
    @current_test = @assessment_participation.unanswered_tests.find_by_hashid(params[:hashid])
    redirect_to candidate_assessment_participation_path(@assessment_participation.id) unless @current_test
  end

  def set_test_service
    @test_service = ParticipationTestService.new(
      ->(key) { session["participation_progress"][key] },
      ->(key, value) { session["participation_progress"][key] = value },
      @current_test, @assessment_participation
    )
  end
end
