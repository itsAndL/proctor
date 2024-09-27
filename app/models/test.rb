class Test < ApplicationRecord
  include Hashid::Rails
  include PgSearch::Model
  include LanguageEnum

  has_many :test_questions, -> { order(position: :asc) }, dependent: :destroy
  has_many :questions, through: :test_questions

  has_many :assessment_tests, -> { order(position: :asc) }, dependent: :destroy
  has_many :assessments, through: :assessment_tests

  has_many :participation_tests, dependent: :destroy
  has_many :assessment_participations, through: :participation_tests

  belongs_to :test_category
  belongs_to :business, optional: true

  validates :title, presence: true, length: { maximum: 60 }
  # validates :overview, :relevancy, length: { maximum: 255 }
  validates :questions_to_answer, :duration_seconds, presence: true,
                                                     numericality: { greater_than: 0, only_integer: true }
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

  def selected_questions
    available_count = active_non_preview_questions.count
    limit = [questions_to_answer, available_count].compact.min
    active_non_preview_questions.order('RANDOM()').limit(limit)
  end

  def preview_questions
    questions.preview.active.order('test_questions.position ASC')
  end

  def self.types
    %w[coding_test multiple_choice_test questionnaire_test]
  end

  def next_preview(test_question)
    next_question_of_type(true, test_question:)
  end

  def next_non_preview(test_question)
    next_question_of_type(false, test_question:)
  end

  def previous_preview(test_question)
    previous_question_of_type(true, test_question:)
  end

  def previous_non_preview(test_question)
    previous_question_of_type(false, test_question:)
  end

  private

  def next_question_of_type(is_preview, test_question:, is_active: true)
    next_question = test_questions.joins(:question)
                                  .where('test_questions.position > ?', test_question.position)
                                  .where(questions: { preview: is_preview })
                                  .where(questions: { active: is_active })
                                  .order('test_questions.position ASC')
                                  .first
    next_question&.question
  end

  def previous_question_of_type(is_preview, test_question:, is_active: true)
    prev_question = test_questions.joins(:question)
                                  .where('test_questions.position < ?', test_question.position)
                                  .where(questions: { preview: is_preview })
                                  .where(questions: { active: is_active })
                                  .order('test_questions.position DESC')
                                  .first
    prev_question&.question
  end

  def active_non_preview_questions
    @active_non_preview_questions ||= questions.non_preview.active
  end
end
