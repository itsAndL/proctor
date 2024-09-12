class Assessment < ApplicationRecord
  include Hashid::Rails
  include PgSearch::Model
  include LanguageEnum

  belongs_to :business

  scope :completed, -> { where(status: :completed) }
  scope :archived, -> { where.not(archived_at: nil) }

  scope :active, lambda {
    where(archived_at: nil)
      .where(
        id: AssessmentParticipation.select(:assessment_id).distinct
      )
  }

  scope :inactive, lambda {
    where(archived_at: nil)
      .where.not(
        id: AssessmentParticipation.select(:assessment_id).distinct
      )
  }

  validates :title, :language, presence: true
  validate :max_five_tests

  has_many :assessment_tests, -> { order(position: :asc) }, dependent: :destroy
  has_many :tests, through: :assessment_tests

  has_many :assessment_custom_questions, -> { order(position: :asc) }, dependent: :destroy
  has_many :custom_questions, through: :assessment_custom_questions

  has_many :assessment_participations, dependent: :destroy
  has_many :temp_candidates, through: :assessment_participations
  has_many :candidates, through: :assessment_participations
  has_many :question_answers, through: :assessment_participations
  has_many :custom_question_responses, through: :assessment_participations

  pg_search_scope :filter_by_search_query,
                  against: :title,
                  using: {
                    tsearch: { prefix: true }
                  }

  before_create :set_public_link_token

  def best_candidate_score
    completed_participations = assessment_participations.completed

    return nil if completed_participations.empty?

    best_score = completed_participations.map do |participation|
      participation.evaluate_full_assessment.overall_score_percentage
    end.compact.max

    best_score&.round(2)
  end

  def candidate_pool_average
    completed_participations = assessment_participations.completed

    return nil if completed_participations.empty?

    total_score = completed_participations.sum do |participation|
      score = participation.evaluate_full_assessment.overall_score_percentage
      score.to_f # Convert nil to 0.0 and ensure float division
    end

    average_score = total_score / completed_participations.count
    average_score.round(2)
  end

  def duration_seconds
    tests_duration + custom_questions_duration
  end

  def archived?
    archived_at.present?
  end

  def archive!
    update!(archived_at: Time.current)
  end

  def unarchive!
    update!(archived_at: nil)
  end

  def activate_public_link!
    update!(public_link_active: true)
  end

  def deactivate_public_link!
    update!(public_link_active: false)
  end

  def public_link_active?
    public_link_active
  end

  def progress
    rand(0..100)
  end

  def parts_count
    tests.count + custom_questions.count
  end

  def last_activity
    [
      assessment_participations.maximum(:updated_at),
      question_answers.maximum(:updated_at),
      custom_question_responses.maximum(:updated_at),
      updated_at
    ].compact.max
  end

  private

  def max_five_tests
    return if assessment_tests.size <= 5

    errors.add(:base, 'An assessment can have a maximum of 5 tests')
  end

  def tests_duration
    tests.sum(&:duration_seconds)
  end

  def custom_questions_duration
    custom_questions.sum(:duration_seconds)
  end

  def set_public_link_token
    self.public_link_token = generate_unique_token
  end

  def generate_unique_token
    loop do
      token = SecureRandom.urlsafe_base64(8)
      break token unless Assessment.exists?(public_link_token: token)
    end
  end
end
