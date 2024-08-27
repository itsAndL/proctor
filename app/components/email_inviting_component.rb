# frozen_string_literal: true

class EmailInvitingComponent < ViewComponent::Base
  def initialize(assessment:)
    @assessment = assessment
  end
end
