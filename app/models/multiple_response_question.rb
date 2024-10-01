class MultipleResponseQuestion < Question
  include OptionValidatable

  validate :at_least_one_correct_option

  def self.min_options
    2
  end

  private

  def at_least_one_correct_option
    return unless options.none?(&:correct?)

    errors.add(:base, 'Must have at least one correct option')
  end
end
