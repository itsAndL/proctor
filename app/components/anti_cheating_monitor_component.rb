# frozen_string_literal: true

class AntiCheatingMonitorComponent < ViewComponent::Base
  def initialize(assessment_participation:)
    @assessment_participation = assessment_participation
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

  def started_or_completed?
    @assessment_participation.started? || @assessment_participation.completed?
  end

  private

  def check_status(attribute)
    return "N/A" unless started_or_completed?

    value = @assessment_participation.send(attribute)
    case value
    when true
      ["Yes", :positive]
    when false
      ["No", :negative]
    else
      "N/A"
    end
  end
end
