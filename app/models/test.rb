class Test < ApplicationRecord
  include Hashid::Rails

  belongs_to :test_type

  validates :title, :overview, :description, :level, :relevancy, presence: true

  enum level: { entry_level: 0, intermediate: 1, advanced: 2 }

  attribute :type, :string

  def type
    test_type&.title
  end
end
