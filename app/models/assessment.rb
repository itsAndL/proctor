class Assessment < ApplicationRecord
  include Hashid::Rails

  belongs_to :business

  validates :title, :language, presence: true
  validate :max_five_tests

  enum language: { en: 0, fr: 1 }

  has_many :assessment_tests, -> { order(position: :asc) }, dependent: :destroy
  has_many :tests, through: :assessment_tests

  has_many :assessment_custom_questions, -> { order(position: :asc) }, dependent: :destroy
  has_many :custom_questions, through: :assessment_custom_questions

  private

  def max_five_tests
    return if assessment_tests.size <= 5

    errors.add(:base, 'An assessment can have a maximum of 5 tests')
  end
end
