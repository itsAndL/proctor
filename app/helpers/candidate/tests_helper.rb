module Candidate::TestsHelper
  def find_assessment_test(test, assessment)
    AssessmentTest.find_by(test:, assessment:)
  end

  def find_assessment_participation_from_session
    participation_id = session.dig('participation_progress', 'current_assessment_participation_id')
    AssessmentParticipation.find_by(id: participation_id)
  end

  def find_current_test
    @assessment_participation.unanswered_tests.find(params[:hashid])
  end

  def question_form_component
    QuestionAnsweringFormComponent.new(
      business: @assessment_participation.assessment.business,
      passed_questions_count: @test_service.passed_questions_count,
      questions_count: @test_service.questions_count,
      question: @test_service.current_question,
      test: @current_test,
      is_preview: @test_service.preview,
      question_started_at: @test_service.question_started_at,
      save_answer_path: save_answer_candidate_test_path(@current_test)
    )
  end

  def redirect_based_on_test_status(current_test, assessment_participation)
    if current_test
      next_test = assessment_participation.unanswered_tests.first
      if next_test.present?
        candidate_test_path(next_test)
      else
        checkout_candidate_assessment_participation_path(assessment_participation)
      end
    else
      candidate_assessment_participations_path(assessment_participation.id)
    end
  end

  def handle_service_action(action, service, params = nil)
    if params
      service.send(action, params)
    else
      service.send(action)
    end

    yield if block_given?
  rescue ParticipationTestErrors::TestNotFoundError,
         ParticipationTestErrors::TestQuestionNotFoundError => e
    dd
    log_error(e.message)
    redirect_to start_candidate_test_path(@current_test)
  rescue ParticipationTestErrors::QuestionNotFoundError,
         ParticipationTestErrors::NoCurrentQuestionError,
         ParticipationTestErrors::InvalidTestSetupError => e
    log_error(e.message)
    redirect_to candidate_test_path(@current_test)
    # rescue StandardError => e
    #   log_error("An unexpected error occurred: #{e.message}")
    #   redirect_to candidate_assessment_participations_path
  end

  def log_error(message)
    Rails.logger.error(message)
    puts "Error: #{message}"
  end
end
