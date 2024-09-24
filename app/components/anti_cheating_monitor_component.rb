# frozen_string_literal: true

class AntiCheatingMonitorComponent < ViewComponent::Base
  def initialize(assessment_participation:)
    @assessment_participation = assessment_participation
    @screenshots = @assessment_participation.screenshots.order(:created_at)
  end

  def device_used
    @assessment_participation.device_used || "N/A"
  end

  def location
    @assessment_participation.location || "N/A"
  end

  def ip_address_check
    check_status(:single_ip_address)
  end

  def webcam_enabled
    check_status(:webcam_enabled)
  end

  def fullscreen_active
    check_status(:fullscreen_always_active)
  end

  def mouse_in_window
    check_status(:mouse_always_in_window)
  end

  def screenshots_json
    @screenshots.map do |screenshot|
      {
        id: screenshot.id,
        thumb_url: screenshot.thumb_url,
        preview_url: screenshot.preview_url,
        full_url: screenshot.full_url,
        timestamp: screenshot.created_at.to_i
      }
    end.to_json
  end

  private

  def check_status(attribute)
    value = @assessment_participation.send(attribute)
    case value
    when true
      [t('.yes'), :positive]
    when false
      [t('.no'), :negative]
    else
      'N/A'
    end
  end
end
