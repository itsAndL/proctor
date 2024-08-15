class Assessment < ApplicationRecord
  include Hashid::Rails
  include PgSearch::Model

  belongs_to :business

  scope :archived, -> { where.not(archived_at: nil) }
  scope :active, -> { where(archived_at: nil) }

  validates :title, :language, presence: true
  validate :max_five_tests

  enum language: { en: 0, fr: 1 }

  has_many :assessment_tests, -> { order(position: :asc) }, dependent: :destroy
  has_many :tests, through: :assessment_tests

  has_many :assessment_custom_questions, -> { order(position: :asc) }, dependent: :destroy
  has_many :custom_questions, through: :assessment_custom_questions

  pg_search_scope :filter_by_search_query,
                  against: :title,
                  using: {
                    tsearch: { prefix: true }
                  }

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

  def progress
    rand(0..100)
  end

  def candidates
    rand(1..15)
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
end
