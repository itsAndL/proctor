# frozen_string_literal: true

class TestCardComponent < ViewComponent::Base
  def initialize(test:, assessment: nil)
    @test = test
    @assessment = assessment
  end

  private

  def preview_question_path
    test_library_preview_question_path(@test, @test.preview_questions.first) if @test.preview_questions.any?
  end
end
