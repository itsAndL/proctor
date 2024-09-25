module OptionValidatable
  extend ActiveSupport::Concern

  included do
    validate :options_count_within_range
  end

  private

  def options_count_within_range
    option_count = options.size
    min_options = self.class.min_options
    if option_count < min_options
      errors.add(:base, "Must have at least #{min_options} option(s)")
    elsif option_count > 10
      errors.add(:base, 'Can have a maximum of 10 options')
    end
  end
end
