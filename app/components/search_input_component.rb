# frozen_string_literal: true

class SearchInputComponent < ViewComponent::Base
  def initialize(form:, placeholder: nil)
    @form = form
    @placeholder = placeholder || t('.default_placeholder')
  end
end