# frozen_string_literal: true

class StarRatingComponent < ViewComponent::Base
  def initialize(rating:)
    @rating = rating || 0
  end
end
