class Question < ApplicationRecord
  include Questionable

  has_many :test_questions, -> { order(position: :asc) }, dependent: :destroy
  has_many :tests, through: :test_question

  validates :active, presence: true

  scope :preview, -> { where(preview: true) }
  scope :non_preview, -> { where(preview: false) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
