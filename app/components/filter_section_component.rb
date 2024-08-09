# frozen_string_literal: true

class FilterSectionComponent < ViewComponent::Base
  def initialize(title:, options:, expanded: false)
    @title = title
    @options = options
    @expanded = expanded
  end
end
