# frozen_string_literal: true

class ParticipationSetupComponent < ViewComponent::Base
  def initialize(assessment_participation:, title:, next_url:, monitoring: true, intro: false)
    super
    @title = title
    @next_url = next_url
    @assessment_participation = assessment_participation
    @monitoring = monitoring
    @intro = intro
  end

  def countdown_time
    10
  end

  def monitoring_attributes
    return {} unless @monitoring

    {
      'data-controller': 'monitoring',
      'data-monitoring-device-value': 'true',
      'data-monitoring-location-value': 'true',
      'data-monitoring-ip-value': 'true',
      'data-monitoring-webcam-value': 'true',
      'data-monitoring-periodic-webcam-capture-value': 'true',
      'data-monitoring-fullscreen-value': 'true',
      'data-monitoring-track-fullscreen-value': 'true',
      'data-monitoring-track-mouse-value': 'true',
      'data-monitoring-assessment-participation-hash-id-value': @assessment_participation&.hashid
    }
  end
end
