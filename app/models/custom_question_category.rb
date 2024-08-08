class CustomQuestionCategory < ApplicationRecord
  validates :title, presence: true

  has_many :custom_questions, dependent: :nullify
end
