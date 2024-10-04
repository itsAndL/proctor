# frozen_string_literal: true

class ShareLinkComponent < ViewComponent::Base
  def initialize(assessment:)
    @assessment = assessment
  end

  private

  def normalized_root_url
    @normalized_root_url ||= helpers.normalize_url(root_url)
  end

  def normalized_public_assessment_url
    @normalized_public_assessment_url ||= helpers.normalize_url(public_assessment_url(@assessment.public_link_token))
  end
end
