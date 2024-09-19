# frozen_string_literal: true

class ParticipationFeedbackComponent < ViewComponent::Base
  def initialize(assessment_participation:, title:, next_url: nil, monitoring: true)
    super
    @assessment_participation = assessment_participation
    @title = title
    @next_url = next_url
  end

  def countdown_time
    10
  end

  def monitoring_data
    {
      'device': true,
      'location': true,
      'ip': true,
      'webcam': true,
      'periodic-webcam-capture': true,
      'fullscreen': true,
      'track-fullscreen': true,
      'track-mouse': true,
      'assessment-participation-hash-id': @assessment_participation.hashid
    }.freeze
  end
end
