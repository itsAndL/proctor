# frozen_string_literal: true

class EmptyTestResultsComponent < ViewComponent::Base
  def initialize(title: nil, description: nil)
    @title = title
    @description = description
  end

  def title
    @title || t('.default_title')
  end

  def description
    @description || t('.default_description')
  end
end
