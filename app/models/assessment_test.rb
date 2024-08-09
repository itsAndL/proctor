class AssessmentTest < ApplicationRecord
  include Hashid::Rails

  belongs_to :assessment
  belongs_to :test

  acts_as_list scope: :assessment
end
