# frozen_string_literal: true

class QuestionAnsweringFormComponent < ViewComponent::Base
  def initialize(business:, passed_questions_count:,questions_count:, question:, test:, is_preview:, question_started_at:, save_answer_path:)
    @current_business = business
    @passed_questions_count = passed_questions_count
    @questions_count = questions_count
    @question = question
    @test = test
    @preview = is_preview
    @save_answer_path = save_answer_path
    @question_started_at = question_started_at
  end

  def calculate_duration_left
    return unless @question_started_at
    if @preview
      return 60
    end
    duration_left = @question.duration_seconds - (Time.now.to_i - Time.parse(@question_started_at).to_i)
    duration_left.positive? ? duration_left : 0
  end
end
