class CustomQuestion < ApplicationRecord
  include Hashid::Rails
  include PgSearch::Model

  belongs_to :custom_question_category
  has_rich_text :content

  validates :title, :content, :relevancy, :look_for, :type, presence: true

  has_many :assessment_custom_questions, -> { order(position: :asc) }, dependent: :destroy
  has_many :assessments, through: :assessment_custom_questions

  pg_search_scope :filter_by_search_query,
                  against: :title,
                  using: {
                    tsearch: { prefix: true } # Enables prefix matching
                  }

  def category
    custom_question_category&.title
  end

  def category=(value)
    self.custom_question_category = CustomQuestionCategory.find_or_create_by(title: value)
  end

  def self.types
    %w[essay_custom_question file_upload_custom_question video_custom_question]
  end
end
