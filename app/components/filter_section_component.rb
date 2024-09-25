# frozen_string_literal: true

class FilterSectionComponent < ViewComponent::Base
  def initialize(title:, options:, expanded: false)
    @title = title
    @options = options
    @expanded = expanded
  end

  def input_type(option)
    return 'select' if option[:options].is_a?(Array)

    option[:name].end_with?('[]') ? 'checkbox' : 'radio'
  end
end
