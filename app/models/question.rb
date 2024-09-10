class Question < ApplicationRecord
  include Questionable

  has_many :test_questions, -> { order(position: :asc) }, dependent: :destroy
  has_many :tests, through: :test_question

  validates :active, presence: true
  validate :validate_duration_seconds

  scope :preview, -> { where(preview: true) }
  scope :non_preview, -> { where(preview: false) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def next_preview(test)
    next_question_of_type(test, true, true)
  end

  def next_non_preview(test)
    next_question_of_type(test, false, true)
  end

  def previous_preview(test)
    previous_question_of_type(test, true, true)
  end

  def previous_non_preview(test)
    previous_question_of_type(test, false, true)
  end

  private

  def validate_duration_seconds
    return if preview # Skip validation for preview questions

    if duration_seconds.nil? || duration_seconds.to_i <= 0
      errors.add(:duration_seconds, "must be greater than 0 for non-preview questions")
    end
  end

  def next_question_of_type(test, is_preview, is_active = true)
    test_question = test_questions.find_by(test:)
    return nil unless test_question

    next_question = TestQuestion.joins(:question)
                                .where(test:)
                                .where('test_questions.position > ?', test_question.position)
                                .where(questions: { preview: is_preview })
                                .where(questions: { active: is_active })
                                .order('test_questions.position ASC')
                                .first
    next_question&.question
  end

  def previous_question_of_type(test, is_preview, is_active = true)
    test_question = test_questions.find_by(test:)
    return nil unless test_question

    prev_question = TestQuestion.joins(:question)
                                .where(test:)
                                .where('test_questions.position < ?', test_question.position)
                                .where(questions: { preview: is_preview })
                                .where(questions: { active: is_active })
                                .order('test_questions.position DESC')
                                .first
    prev_question&.question
  end
end
