class AssessmentParticipation < ApplicationRecord
  include Hashid::Rails
  include PgSearch::Model

  belongs_to :assessment
  belongs_to :temp_candidate, optional: true
  belongs_to :candidate, optional: true

  has_many :question_answers, dependent: :destroy
  has_many :custom_question_responses, dependent: :destroy
  has_many :screenshots, dependent: :destroy

  enum status: { invited: 0, invitation_clicked: 1, started: 2, completed: 3 }

  validates :status, presence: true
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true
  validates :assessment_id, uniqueness: {
                              scope: [:candidate_id, :temp_candidate_id],
                              message: "Candidate has already been invited to this assessment",
                            }

  validate :candidate_or_temp_candidate_present

  pg_search_scope :filter_by_search_query,
                  associated_against: {
                    candidate: :name,
                    temp_candidate: :name,
                  },
                  using: {
                    tsearch: { prefix: true },
                  }

  def compute_test_result(test)
    total_questions = test.non_preview_questions.count
    answered_questions = question_answers.joins(:test_question).where(test_questions: { test_id: test.id }).count
    correct_answers = question_answers.joins(:test_question).where(test_questions: { test_id: test.id }, is_correct: true).count

    is_test_completed = (answered_questions == total_questions)
    score_percentage = if is_test_completed && total_questions > 0
        (correct_answers.to_f / total_questions * 100).round(2)
      end

    OpenStruct.new(
      test_id: test.id,
      test_name: test.title,
      total_questions: total_questions,
      answered_questions: answered_questions,
      correct_answers: correct_answers,
      score_percentage: score_percentage,
      is_completed: is_test_completed,
    )
  end

  def evaluate_full_assessment
    test_scores = assessment.tests.map { |test| compute_test_result(test) }
    total_questions = test_scores.sum(&:total_questions)
    total_answered = test_scores.sum(&:answered_questions)
    total_correct = test_scores.sum(&:correct_answers)

    is_assessment_completed = (total_answered == total_questions)
    overall_percentage = if is_assessment_completed && total_questions > 0
        (total_correct.to_f / total_questions * 100).round(2)
      end

    OpenStruct.new(
      test_scores: test_scores,
      total_questions: total_questions,
      total_answered_questions: total_answered,
      total_correct_answers: total_correct,
      overall_score_percentage: overall_percentage,
      is_completed: is_assessment_completed,
    )
  end

  def participant
    candidate || Candidate.find_by_email(temp_candidate.email) || temp_candidate
  end

  def last_activity
    [
      question_answers.maximum(:updated_at),
      custom_question_responses.maximum(:updated_at),
      updated_at
    ].compact.max
  end

  def questions_answered_count(test)
    question_answers.joins(:test_question).where(test_questions: { test_id: test.id }).count
  end

  def unanswered_tests
    # Collect the IDs of tests with unanswered questions
    test_ids = assessment.tests.select do |test|
      total_questions = test.non_preview_questions.count
      answered_questions = questions_answered_count(test)
      answered_questions < total_questions
    end.map(&:id) # Extract IDs from the test objects

    # Fetch tests with the collected IDs
    Test.where(id: test_ids)
  end


  def unanswered_custom_questions
    assessment.custom_questions
  end

  def first_unanswered_test
    unanswered_tests&.first
  end

  private

  def candidate_or_temp_candidate_present
    return unless candidate.blank? && temp_candidate.blank?

    errors.add(:base, "Either candidate or temp candidate must be present")
  end
end
