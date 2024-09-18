class ParticipationTest < ApplicationRecord
  belongs_to :assessment_participation
  belongs_to :test
  enum status: { pending: 0, started: 1, completed: 2 }

  after_find :set_completed_if_time_exceeded

  def calculate_time_taken
    (Time.current.to_i - (started_at || 0).to_i)
  end

  def questions_answered_count
    assessment_participation.question_answers.joins(:test_question).where(test_questions: { test_id: test.id }).count
  end

  def answered_questions
    # Get IDs of answered questions
    answered_question_ids = QuestionAnswer
                            .where(assessment_participation:)
                            .joins(:test_question)
                            .where(test_questions: { test_id: test.id })
                            .pluck(:question_id)

    # Fetch the questions using the IDs
    test.selected_questions.where(id: answered_question_ids)
  end

  def answered_questions_count
    assessment_participation.question_answers.joins(:test_question).where(test_questions: { test_id: test.id }).count
  end

  def unanswered_questions
    test.selected_questions - answered_questions
  end

  def more_time?
    test.duration_seconds > calculate_time_taken
  end

  private

  def set_completed_if_time_exceeded
    return if pending? || calculate_time_taken < test.duration_seconds

    status.completed!
  end
end
