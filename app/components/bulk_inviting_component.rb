# frozen_string_literal: true

class BulkInvitingComponent < ViewComponent::Base
  def initialize(assessment:)
    @assessment = assessment
  end
end
