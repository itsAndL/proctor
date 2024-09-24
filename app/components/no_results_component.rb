# frozen_string_literal: true

class NoResultsComponent < ViewComponent::Base
  def initialize(title: nil, message: nil, linkeable: false)
    @title = title || t('.default_title')
    @message = message || t('.default_message')
    @linkeable = linkeable
  end
end