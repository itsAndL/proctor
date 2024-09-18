# frozen_string_literal: true

class NoResultsComponent < ViewComponent::Base
  def initialize(title: nil, message: nil, linkeable: false)
    @title = title || 'Sorry, no results were found.'
    @message = message || 'Try a new search or apply a different filter.'
    @linkeable = linkeable
  end
end
