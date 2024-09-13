class AssessmentParticipation < ApplicationRecord
  include Hashid::Rails
  include PgSearch::Model

  belongs_to :assessment
  belongs_to :temp_candidate, optional: true
  belongs_to :candidate, optional: true

  has_many :question_answers, dependent: :destroy
  has_many :custom_question_responses, dependent: :destroy
  has_many :screenshots, dependent: :destroy

  delegate :tests, to: :assessment
  delegate :custom_questions, to: :assessment

  enum status: { invited: 0, invitation_clicked: 1, started: 2, completed: 3 }

  validates :status, presence: true
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 },
                     allow_nil: true
  validates :assessment_id, uniqueness: {
    scope: %i[candidate_id temp_candidate_id],
    message: 'Candidate has already been invited to this assessment'
  }

  validate :candidate_or_temp_candidate_present

  pg_search_scope :filter_by_search_query,
                  associated_against: {
                    candidate: :name,
                    temp_candidate: :name
                  },
                  using: {
                    tsearch: { prefix: true }
                  }

  def custom_question_completed?(custom_question)
    custom_question_responses.exists?(custom_question_id: custom_question.id)
  end

  def compute_test_result(test)
    total_questions = test.selected_questions.count

    correct_answers = question_answers.joins(:test_question).where(test_questions: { test_id: test.id },
                                                                   is_correct: true).count

    is_test_completed = (questions_answered_count(test) == total_questions)
    score_percentage = if is_test_completed && total_questions > 0
                         (correct_answers.to_f / total_questions * 100).round(2)
                       end

    OpenStruct.new(
      test_id: test.id,
      test_name: test.title,
      total_questions:,
      answered_questions: questions_answered_count(test),
      correct_answers:,
      score_percentage:,
      is_completed: is_test_completed
    )
  end

  def evaluate_full_assessment
    test_scores = tests.map { |test| compute_test_result(test) }

    is_assessment_completed = test_scores.all?(&:is_completed)

    overall_percentage = if is_assessment_completed
                           valid_scores = test_scores.map(&:score_percentage).compact
                           if valid_scores.any?
                             (valid_scores.sum / valid_scores.size).round(2)
                           end
                         end

    OpenStruct.new(
      test_scores:,
      overall_score_percentage: overall_percentage,
      is_completed: is_assessment_completed
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
    questions_answeres(test).count
  end

  def questions_answeres(test)
    question_answers.joins(:test_question).where(test_questions: { test_id: test.id })
  end

  def unanswered_tests
    # Collect the IDs of tests with unanswered questions
    test_ids = tests.select do |test|
      total_questions = test.selected_questions.count
      answered_questions = questions_answered_count(test)
      answered_questions < total_questions
    end.map(&:id) # Extract IDs from the test objects

    # Fetch tests with the collected IDs
    Test.where(id: test_ids)
  end

  def unanswered_custom_questions
    assessment.custom_questions - custom_question_responses.map(&:custom_question)
  end

  def answered_tests
    Test.where(id: tests.map(&:id) - unanswered_tests.map(&:id))
  end

  def answered_questions(test)
    test.questions.select do |question|
      test_question = test.test_questions.find_by(question_id: question.id)
      QuestionAnswer.exists?(test_question_id: test_question.id, assessment_participation_id: id)
    end
  end

  def unanswered_questions(test)
    test.selected_questions - answered_questions(test)
  end

  def time_left
    # TODO: add also calculation of time left for custom questions
    custom_question_time_lef = unanswered_custom_questions.sum(&:duration_seconds)
    unanswered_tests.sum { |test| test.unanswered_questions.sum(&:duration_seconds) } + custom_question_time_lef
  end

  private

  def candidate_or_temp_candidate_present
    return unless candidate.blank? && temp_candidate.blank?

    errors.add(:base, 'Either candidate or temp candidate must be present')
  end
end
