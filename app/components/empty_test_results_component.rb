# frozen_string_literal: true

class EmptyTestResultsComponent < ViewComponent::Base
  def initialize(title: nil, description: nil)
    @title = title || t('.default_title')
    @description = description || t('.default_description')
  end
end
