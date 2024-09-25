# frozen_string_literal: true

class NoResultsComponent < ViewComponent::Base
  def initialize(title: nil, message: nil, linkeable: false)
    @title = title
    @message = message
    @linkeable = linkeable
  end

  def title
    @title || t('.default_title')
  end

  def message
    @message || t('.default_message')
  end
end
