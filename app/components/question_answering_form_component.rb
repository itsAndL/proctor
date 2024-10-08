# frozen_string_literal: true

class QuestionAnsweringFormComponent < ViewComponent::Base
  def initialize(question:, save_path:, test: nil, assessment_participation: nil, business: nil, show_progress: true, monitoring: true)
    super()
    @current_business = business || assessment_participation.assessment.business
    @assessment_participation = assessment_participation
    @question = question
    @test = test
    @show_progress = show_progress
    @participation_test = assessment_participation&.participation_tests&.find_by(test:)
    @save_path = save_path
    @test_started_at = @participation_test&.started_at
    @monitoring = monitoring
  end

  def self.with_custom_question(question:, save_path:, assessment_participation: nil)
    new(question:, save_path:, assessment_participation:)
  end

  def calculate_duration_left
    return custom_question_time_left if custom_question?
    return 60 if @question.preview
    return 0 unless @test_started_at

    duration_left = @test.duration_seconds - (Time.now - @test_started_at).to_i
    duration_left.positive? ? duration_left : 0
  end

  def duration
    return @question.duration_seconds if custom_question?
    return 60 if @question.preview

    @test&.duration_seconds || 0
  end

  def monitoring_attributes
    return {} unless @monitoring

    {
      'data-controller': 'monitoring',
      'data-monitoring-device-value': 'true',
      'data-monitoring-location-value': 'true',
      'data-monitoring-ip-value': 'true',
      'data-monitoring-webcam-value': 'true',
      'data-monitoring-periodic-webcam-capture-value': 'true',
      'data-monitoring-fullscreen-value': 'true',
      'data-monitoring-track-fullscreen-value': 'true',
      'data-monitoring-track-mouse-value': 'true',
      'data-monitoring-assessment-participation-hash-id-value': @assessment_participation&.hashid
    }
  end

  private

  def custom_question_time_left
    custom_question_response = @assessment_participation.custom_question_responses.find_by(custom_question: @question)
    custom_question_response.duration_left
  end

  def custom_question?
    @question.is_a?(CustomQuestion)
  end
end
