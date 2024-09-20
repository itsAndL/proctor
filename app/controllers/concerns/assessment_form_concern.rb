# frozen_string_literal: true

module AssessmentFormConcern
  extend ActiveSupport::Concern

  def question_form
    QuestionAnsweringFormComponent.new(
      assessment_participation: @assessment_participation,
      question: @current_question,
      test: @current_test,
      save_path: save_answer_candidate_test_path(@current_test)
    )
  end

  def custom_question_form
    QuestionAnsweringFormComponent.with_custom_question(
      assessment_participation: @assessment_participation,
      question: @current_custom_question,
      save_path: save_answer_candidate_custom_question_path(@current_custom_question)
    )
  end

  def find_assessment_participation_from_session
    participation_id = session.dig('participants', 'assessment_participation_id')
    AssessmentParticipation.find_by(id: participation_id)
  end
end
