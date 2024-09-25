module MultipleChoiceQuestionable
  extend ActiveSupport::Concern

  included do
    include OptionValidatable

    validate :only_one_correct_option
  end

  class_methods do
    def min_options
      2
    end
  end

  private

  def only_one_correct_option
    return unless options.select(&:correct?).count != 1

    errors.add(:base, 'Must have exactly one correct option')
  end
end
