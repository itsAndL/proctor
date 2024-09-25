# frozen_string_literal: true

class NotStartedComponent < ViewComponent::Base
  def initialize(title: nil, message: nil)
    @title = title
    @message = message
  end

  def title
    @title || t('.default_title')
  end

  def message
    @message || t('.default_message')
  end
end
