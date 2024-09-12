class QuestionAnswer < ApplicationRecord
  belongs_to :assessment_participation
  belongs_to :test_question

  validates :content, presence: true
  validates :is_correct, inclusion: {
    in: [true, false],
    message: "can only be set to true or false"
  }
end
