# frozen_string_literal: true

class ParticipationHeaderComponent < ViewComponent::Base
  def initialize(company:)
    @company = company
  end
end
