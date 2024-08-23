class Assessment < ApplicationRecord
  include Hashid::Rails
  include PgSearch::Model

  belongs_to :business

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

  enum language: { en: 0, fr: 1 }

  has_many :assessment_tests, -> { order(position: :asc) }, dependent: :destroy
  has_many :tests, through: :assessment_tests

  has_many :assessment_custom_questions, -> { order(position: :asc) }, dependent: :destroy
  has_many :custom_questions, through: :assessment_custom_questions

  has_many :assessment_participations, dependent: :destroy
  has_many :temp_candidates, through: :assessment_participations
  has_many :candidates, through: :assessment_participations

  pg_search_scope :filter_by_search_query,
                  against: :title,
                  using: {
                    tsearch: { prefix: true }
                  }

  before_create :set_public_link_token

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
