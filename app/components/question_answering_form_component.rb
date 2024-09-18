# frozen_string_literal: true

class QuestionAnsweringFormComponent < ViewComponent::Base
  def initialize(question:, test:, save_path:, assessment_participation: nil, business: nil, show_progress: true)
    super()
    @current_business = business || assessment_participation.assessment.business
    @assessment_participation = assessment_participation
    @question = question
    @test = test
    @show_progress = show_progress
    @participation_test = assessment_participation&.participation_tests&.find_by(test:)
    @save_path = save_path
    @test_started_at = @participation_test&.started_at
  end

  def calculate_duration_left
    return 60 if @question.preview
    return 0 unless @test_started_at
    
    duration_left = @test.duration_seconds - (Time.now - @test_started_at).to_i
    duration_left.positive? ? duration_left : 0
  end

  def question_header
    QuestionHeaderComponent.new(current_business: @current_business, show_progress: @show_progress,
                                question: @question, participation_test: @participation_test, save_path: @save_path)
  end

  def question_form
    QuestionFormComponent.new(question: @question, test: @test, save_path: @save_path)
  end
end
