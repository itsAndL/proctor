class Test < ApplicationRecord
  include Hashid::Rails
  include PgSearch::Model
  include LanguageEnum

  has_many :test_questions, -> { order(position: :asc) }, dependent: :destroy
  has_many :questions, through: :test_questions

  has_many :assessment_tests, -> { order(position: :asc) }, dependent: :destroy
  has_many :assessments, through: :assessment_tests

  belongs_to :test_category
  belongs_to :business, optional: true

  validates :title, presence: true, length: { maximum: 60 }
  # validates :overview, :relevancy, length: { maximum: 255 }
  validates :description, :level, :type, :active, :language, presence: true

  enum level: { entry_level: 0, intermediate: 1, advanced: 2 }

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :accessible_by_business, ->(business) { where(business_id: [nil, business.id]) }
  scope :only_system, -> { where(business_id: nil) }
  scope :only_business, ->(business) { where(business:) }
  scope :sorted, -> { order(position: :asc) }

  pg_search_scope :filter_by_search_query,
                  against: :title,
                  using: {
                    tsearch: { prefix: true }
                  }

  def category
    test_category&.title
  end

  def category=(value)
    self.test_category = TestCategory.find_or_create_by(title: value)
  end

  def duration_seconds
    non_preview_questions.sum(:duration_seconds)
  end

  def preview_questions
    questions.preview.active.order('test_questions.position ASC')
  end

  def non_preview_questions
    questions.non_preview.active.order('test_questions.position ASC')
  end

  def first_preview_question
    preview_questions.first
  end

  def first_non_preview_question
    non_preview_questions.first
  end

  def self.types
    %w[coding_test multiple_choice_test questionnaire_test]
  end
end
