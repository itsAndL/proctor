class MultipleChoiceQuestion < Question
  # Add MultipleChoiceQuestion-specific logic

  has_many :question_options, foreign_key: :question_id, dependent: :destroy, autosave: true

  validate :only_one_correct_option

  private

  def only_one_correct_option
    if question_options.select(&:correct?).count != 1
      errors.add(:base, "Must have exactly one correct option")
    end
  end
end
