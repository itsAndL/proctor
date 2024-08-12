class MultipleResponseQuestion < Question
  # Add MultipleResponseQuestion-specific logic

  validate :at_least_one_correct_option

  private

  def at_least_one_correct_option
    if options.none?(&:correct?)
      errors.add(:base, "Must have at least one correct option")
    end
  end
end
