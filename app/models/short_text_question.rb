class ShortTextQuestion < Question
  include OptionValidatable

  validate :all_options_correct

  def self.min_options
    1
  end

  private

  def all_options_correct
    return if options.all?(&:correct?)

    errors.add(:base, :all_options_must_be_correct)
  end
end
