# frozen_string_literal: true

class QuestionFormComponent < ViewComponent::Base
  def initialize(save_path:, question:, test:)
    super
    @save_path = save_path
    @question = question
    @test = test
  end
end
