class MultipleChoiceQuestion < Question
  # Add MultipleChoiceQuestion-specific logic

  validate :only_one_correct_option

  private

  def only_one_correct_option
    if options.select(&:correct?).count != 1
      errors.add(:base, "Must have exactly one correct option")
    end
  end
end
