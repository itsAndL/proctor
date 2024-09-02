class QuestionAnswer < ApplicationRecord
  belongs_to :assessment_participation
  belongs_to :question
  belongs_to :test

  validates :content, presence: true
  validates :is_correct, inclusion: { in: [true, false] }
end