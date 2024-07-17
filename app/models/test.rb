class Test < ApplicationRecord
  include Hashid::Rails
  include PgSearch::Model

  belongs_to :test_type

  validates :title, :overview, :description, :level, :format, :relevancy, presence: true

  enum level: { entry_level: 0, intermediate: 1, advanced: 2 }
  enum format: { multiple_choice: 0, coding: 1, typing: 2, questionnaire: 3, simulation: 4 }

  pg_search_scope :filter_by_search_query,
                  against: :title,
                  using: {
                    tsearch: { prefix: true } # Enables prefix matching
                  }

  attribute :type, :string

  def type
    test_type&.title
  end
end
