module TestParticipationConcern
  extend ActiveSupport::Concern
  include Candidate::AssessmentParticipationsHelper

  def find_assessment_participation_from_session
    participation_id = session.dig('participants', 'assessment_participation_id')
    AssessmentParticipation.find_by(id: participation_id)
  end

  def question_form_component
    QuestionAnsweringFormComponent.new(
      assessment_participation: @assessment_participation,
      question: @current_question,
      test: @current_test,
      save_path: save_answer_candidate_test_path(@current_test)
    )
  end

  def redirect_based_on_test_status(current_test, assessment_participation)
    next_test = assessment_participation.unanswered_tests.first
    if current_test && next_test.present?
      candidate_test_path(next_test)
    else
      checkout_candidate_assessment_participation_path(assessment_participation)
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
    log_error(e.message)
    redirect_to determine_next_url(@assessment_participation), alert: e.message
  rescue ParticipationTestErrors::QuestionNotFoundError => e
    log_error(e.message)
    redirect_to candidate_test_path(@current_test), alert: e.message
  end

  def log_error(message)
    Rails.logger.error(message)
    puts "Error: #{message}"
  end
end
