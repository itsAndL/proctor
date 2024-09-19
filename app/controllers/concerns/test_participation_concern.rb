module TestParticipationConcern
  extend ActiveSupport::Concern
  include AssessmentParticipationConcern

  def question_form_component
    QuestionAnsweringFormComponent.new(
      assessment_participation: @assessment_participation,
      question: @current_question,
      test: @current_test,
      save_path: save_answer_candidate_test_path(@current_test)
    )
  end
end
