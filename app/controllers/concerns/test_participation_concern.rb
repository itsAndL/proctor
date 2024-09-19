module TestParticipationConcern
  extend ActiveSupport::Concern
  include Candidate::AssessmentParticipationsHelper

  def find_assessment_participation_from_session
    participation_id = session.dig('participants', 'assessment_participation_id')
    AssessmentParticipation.find_by(id: participation_id)
  end

  def question_form_component
    QuestionAnsweringFormComponent.new(
      assessment_participation: @assessment_participation,
      question: @current_question,
      test: @current_test,
      save_path: save_answer_candidate_test_path(@current_test)
    )
  end
end
