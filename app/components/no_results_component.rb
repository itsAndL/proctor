# frozen_string_literal: true

class NoResultsComponent < ViewComponent::Base
  def initialize(try_again: false, suggestion: nil)
    @try_again = try_again
    @suggestion = suggestion
  end

  def take_action?
    @try_again || @suggestion.present?
  end
end
