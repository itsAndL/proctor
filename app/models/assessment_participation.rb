class AssessmentParticipation < ApplicationRecord
  include Hashid::Rails
  include PgSearch::Model
  include Monitorable

  belongs_to :assessment
  belongs_to :temp_candidate, optional: true
  belongs_to :candidate, optional: true

  has_many :question_answers, dependent: :destroy
  has_many :custom_question_responses, dependent: :destroy
  has_many :screenshots, dependent: :destroy
  has_many :participation_tests, dependent: :destroy

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

  def device_used
    devices.last
  end

  def location
    locations.last
  end

  def single_ip_address
    return if ips.blank?

    ips.uniq.count == 1
  end

  def compute_test_result(test)
    total_questions = test.selected_questions.count
    participation_test = participation_tests.find_by(test:)
    correct_answers = question_answers.joins(:test_question).where(test_questions: { test_id: test.id },
                                                                   is_correct: true).count
    questions_answered_count = participation_test&.questions_answered_count || 0

    is_test_completed = (questions_answered_count == total_questions)
    score_percentage = if is_test_completed && total_questions.positive?
                         (correct_answers.to_f / total_questions * 100).round(2)
                       end
    OpenStruct.new(
      test_id: test.id,
      test_name: test.title,
      total_questions:,
      answered_questions: questions_answered_count,
      correct_answers:,
      score_percentage:,
      is_completed: is_test_completed,
      time_taken: (participation_test&.completed_at.to_i - participation_test&.started_at.to_i)
    )
  end

  def evaluate_full_assessment
    test_scores = tests.map { |test| compute_test_result(test) }

    is_assessment_completed = test_scores.all?(&:is_completed)

    overall_percentage = if is_assessment_completed
                           valid_scores = test_scores.map(&:score_percentage).compact
                           (valid_scores.sum / valid_scores.size).round(2) if valid_scores.any?
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

  def unanswered_tests
    incomplete_test_ids = participation_tests
                          .where.not(status: :completed)
                          .pluck(:test_id)

    tests.select { |test| incomplete_test_ids.include?(test.id) }
  end

  def answered_tests
    test_ids = participation_tests.where(status: :completed).pluck(:test_id)
    tests.select { |test| test_ids.include?(test.id) }
  end

  private

  def candidate_or_temp_candidate_present
    return unless candidate.blank? && temp_candidate.blank?

    errors.add(:base, 'Either candidate or temp candidate must be present')
  end
end
