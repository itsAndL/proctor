# frozen_string_literal: true

class EmptyTestResultsComponent < ViewComponent::Base
  def initialize(title: nil, description: nil)
    @title = title || "No tests from the library were included in this assessment."
    @description = description || "Therefore there are no test results to show."
  end
end
