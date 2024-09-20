class ParticipationTest < ApplicationRecord
  include TimeTracking

  belongs_to :assessment_participation
  belongs_to :test

  delegate :duration_seconds, to: :test

  enum status: { pending: 0, started: 1, completed: 2 }

  def questions_answered_count
    assessment_participation
      .question_answers
      .joins(:test_question)
      .where(test_questions: { test_id: test.id })
      .count
  end

  def answered_questions
    test.selected_questions.where(id: assessment_participation
    .question_answers
    .joins(:test_question)
    .where(test_questions: { test_id: test.id })
    .pluck(:question_id))
  end

  def answered_questions_count
    assessment_participation
      .question_answers
      .joins(:test_question)
      .where(test_questions: { test_id: test.id })
      .count
  end

  def unanswered_questions
    test.selected_questions - answered_questions
  end
end
