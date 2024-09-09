class MultipleChoiceQuestion < Question
  include OptionValidatable

  validate :only_one_correct_option

  def self.min_options
    2
  end

  private

  def only_one_correct_option
    if options.select(&:correct?).count != 1
      errors.add(:base, "Must have exactly one correct option")
    end
  end
end
