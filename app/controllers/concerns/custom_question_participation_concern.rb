module CustomQuestionParticipationConcern
  extend ActiveSupport::Concern
  include AssessmentParticipationConcern

  def question_form_component
    QuestionAnsweringFormComponent.with_custom_question(
      assessment_participation: @assessment_participation,
      question: @current_custom_question,
      save_path: save_answer_candidate_custom_question_path(@current_custom_question)
    )
  end
end
