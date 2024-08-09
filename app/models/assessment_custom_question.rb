class AssessmentCustomQuestion < ApplicationRecord
  include Hashid::Rails

  belongs_to :assessment
  belongs_to :custom_question

  acts_as_list scope: :assessment
end
