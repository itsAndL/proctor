# frozen_string_literal: true

class QuestionAnsweringFormComponent < ViewComponent::Base
  def initialize(session_service:, save_answer_path:)
    @session_service = session_service
    @save_answer_path = save_answer_path
  end
end
