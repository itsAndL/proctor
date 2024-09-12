class Candidate::TestsController < ApplicationController
  include Candidate::TestsHelper

  before_action :authenticate_candidate!
  before_action :hide_navbar
  before_action :set_assessment_participation
  before_action :set_current_test, except: %i[feedback]
  before_action :set_test_service, except: %i[feedback show]
  before_action :validate_save_answer_params, only: %i[save_answer]

  def show
    if @current_test.preview_questions.any? && @assessment_participation.answered_questions(@current_test).empty?
      redirect_to intro_candidate_test_path(@current_test)
    else
      redirect_to start_candidate_test_path(@current_test)
    end
  end

  def start
    handle_service_action(:start_test, @test_service)
  end

  def intro
    handle_service_action(:start_practice_test, @test_service)
  end

  def feedback
    @current_test = @assessment_participation.assessment.tests.find(params[:hashid])
    @next_url = redirect_based_on_test_status(@current_test, @assessment_participation)
  end

  def questions
    handle_service_action(:start_question, @test_service) do
      render question_form_component
      # to have always default answer
      # @test_service.answere_question({ selected_options: [], question_id: @test_service.current_question.id })
    end
  end

  def practice_questions
    if @test_service.preview
      handle_service_action(:start_question_preview, @test_service) do
        render question_form_component
      end
    else
      redirect_to questions_candidate_test_path(@current_test)
    end
  end

  def save_answer
    handle_service_action(:answere_question, @test_service, params:) do
      if @test_service.more_questions?
        render turbo_stream: turbo_stream.replace('question-form', question_form_component)
      elsif @test_service.preview
        redirect_to start_candidate_test_path(@current_test)
      else
        redirect_to feedback_candidate_test_path(@current_test)
      end
    end
  end

  private

  def validate_save_answer_params
    # params.require(:selected_options)
    params.require(:question_id)
  end

  def set_assessment_participation
    @assessment_participation = find_assessment_participation_from_session
    redirect_to candidate_assessment_participations_path unless @assessment_participation
  end

  def set_current_test
    @current_test = find_current_test
    redirect_to candidate_assessment_participation_path(@assessment_participation) unless @current_test
  end

  def set_test_service
    @test_service = ParticipationTestService.new(
      ->(key) { session['participation_progress'][key] },
      ->(key, value) { session['participation_progress'][key] = value },
      @current_test, @assessment_participation
    )
  end
end
