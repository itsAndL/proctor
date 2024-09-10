class AssessmentTest < ApplicationRecord
  include Hashid::Rails

  belongs_to :assessment
  belongs_to :test

  acts_as_list scope: :assessment

  def answered_questions(assessment_participation_id)
    test.questions.select do |question|
      test_question = test.test_questions.find_by(question_id: question.id)
      QuestionAnswer.exists?(test_question_id: test_question.id, assessment_participation_id: assessment_participation_id)
    end
  end

  def unanswered_questions(assessment_participation_id)
    test.non_preview_questions - answered_questions(assessment_participation_id)
  end
end
