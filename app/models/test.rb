class Test < ApplicationRecord
  include Hashid::Rails
  include PgSearch::Model

  belongs_to :test_category

  validates :title, :overview, :description, :level, :relevancy, presence: true

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

  def self.types
    %w[coding_test multiple_choice_test questionnaire_test]
  end
end
