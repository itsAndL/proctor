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
      errors.add(:base, :too_few_options, min_options:)
    elsif option_count > 10
      errors.add(:base, :too_many_options)
    end
  end
end
