# frozen_string_literal: true

class NoResultsComponent < ViewComponent::Base
  def initialize(title: nil, message: nil, linkeable: false, svg: nil, action_link: nil, action_title: nil)
    @title = title
    @message = message
    @linkeable = linkeable
    @svg = svg
    @action_link = action_link
    @action_title = action_title
  end

  def title
    @title || t('.default_title')
  end

  def message
    @message || t('.default_message')
  end
end
