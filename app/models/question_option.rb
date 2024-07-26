class QuestionOption < ApplicationRecord
  belongs_to :question
  has_rich_text :content

  validates :content, presence: true
end
