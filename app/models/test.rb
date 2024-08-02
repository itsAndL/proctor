class Test < ApplicationRecord
  include Hashid::Rails
  include PgSearch::Model

  has_many :test_questions, -> { order(position: :asc) }, dependent: :destroy
  has_many :questions, through: :test_questions

  has_many :assessment_tests, -> { order(position: :asc) }, dependent: :destroy
  has_many :assessments, through: :assessment_test

  belongs_to :test_category

  validates :title, :overview, :description, :level, :relevancy, :type, presence: true

  enum level: { entry_level: 0, intermediate: 1, advanced: 2 }

  pg_search_scope :filter_by_search_query,
                  against: :title,
                  using: {
                    tsearch: { prefix: true } # Enables prefix matching
                  }

  attribute :category, :string

  def category
    test_category&.title
  end

  def category=(value)
    self.test_category = TestCategory.find_or_create_by(title: value)
  end

  def preview_questions
    questions.preview.order('test_questions.position ASC')
  end

  def non_preview_questions
    questions.non_preview.order('test_questions.position ASC')
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
