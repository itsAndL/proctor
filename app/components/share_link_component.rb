# frozen_string_literal: true

class ShareLinkComponent < ViewComponent::Base
  def initialize(assessment:)
    @assessment = assessment
  end
end
