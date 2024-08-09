# frozen_string_literal: true

class NoResultsComponent < ViewComponent::Base
  def initialize(library:, clear_path:)
    @library = library
  end
end
