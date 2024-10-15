# frozen_string_literal: true

class SearchInputComponent < ViewComponent::Base
  def initialize(form:, placeholder: nil)
    @form = form
    @placeholder = placeholder
  end

  def placeholder
    @placeholder || t('search_input_component.default_placeholder')
  end
end
