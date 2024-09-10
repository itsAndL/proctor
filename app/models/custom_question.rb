class CustomQuestion < ApplicationRecord
  include Questionable
  include PgSearch::Model

  belongs_to :custom_question_category
  belongs_to :business, optional: true

  validates :title, presence: true, length: { maximum: 60 }

  has_many :assessment_custom_questions, -> { order(position: :asc) }, dependent: :destroy
  has_many :assessments, through: :assessment_custom_questions

  has_many :custom_question_responses, dependent: :destroy
  has_many :options, as: :optionable, dependent: :destroy, autosave: true

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
    custom_question_category&.title
  end

  def category=(value)
    self.custom_question_category = CustomQuestionCategory.find_or_create_by(title: value)
  end

  def self.types
    %w[essay_custom_question file_upload_custom_question video_custom_question multiple_choice_custom_question]
  end
end
