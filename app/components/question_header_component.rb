# frozen_string_literal: true

class QuestionHeaderComponent < ViewComponent::Base
  def initialize(current_business:, show_progress:, question:, participation_test:, save_path: nil, test: nil)
    super
    @current_business = current_business
    @show_progress = show_progress
    if participation_test
      if question.preview
        @answered_questions_count = participation_test.test.preview_questions.index(question) + 1
        @questions_count = participation_test.test.preview_questions.count
      else
        @answered_questions_count = participation_test.answered_questions.count + 1
        @questions_count = participation_test.test.selected_questions.count
      end
      @test = participation_test.test
      @participant_test = participation_test
    end
    @question = question
    @test = test
    @save_path = save_path
  end

  private

  def calculate_duration_left
    return 0 unless @show_progress
    return 0 if @participant_test.completed?
    return 60 if @question.preview

    @participant_test.test.duration_seconds - @participant_test.calculate_time_taken
  end
end
