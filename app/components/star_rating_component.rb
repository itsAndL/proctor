# frozen_string_literal: true

class StarRatingComponent < ViewComponent::Base
  def initialize(record)
    @record = record
    @rating = record.rating || 0
  end

  def identifier
    "star-rating-#{@record.class.to_s.underscore}-#{@record.hashid}"
  end
end
