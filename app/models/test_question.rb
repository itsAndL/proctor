class TestQuestion < ApplicationRecord
  belongs_to :test
  belongs_to :question

  has_many :question_answers, dependent: :destroy

  acts_as_list scope: :test
end
