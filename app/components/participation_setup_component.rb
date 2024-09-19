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

