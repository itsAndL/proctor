class Question < ApplicationRecord
  include Hashid::Rails

  has_rich_text :content

  has_many :test_questions, -> { order(position: :asc) }
  has_many :tests, through: :test_question

  has_many :question_options, dependent: :destroy

  validates :content, :type, presence: true

  scope :preview, -> { where(preview: true) }
  scope :non_preview, -> { where(preview: false) }

  def next_preview(test)
    next_question_of_type(test, true)
  end

  def next_non_preview(test)
    next_question_of_type(test, false)
  end

  def previous_preview(test)
    previous_question_of_type(test, true)
  end

  def previous_non_preview(test)
    previous_question_of_type(test, false)
  end

  private

  def next_question_of_type(test, is_preview)
    test_question = test_questions.find_by(test:)
    return nil unless test_question

    next_question = TestQuestion.joins(:question)
                                .where(test:)
                                .where('test_questions.position > ?', test_question.position)
                                .where(questions: { preview: is_preview })
                                .order('test_questions.position ASC')
                                .first
    next_question&.question
  end

  def previous_question_of_type(test, is_preview)
    test_question = test_questions.find_by(test:)
    return nil unless test_question

    prev_question = TestQuestion.joins(:question)
                                .where(test:)
                                .where('test_questions.position < ?', test_question.position)
                                .where(questions: { preview: is_preview })
                                .order('test_questions.position DESC')
                                .first
    prev_question&.question
  end
end
