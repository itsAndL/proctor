# frozen_string_literal: true

class NotificationComponent < ViewComponent::Base
  def initialize(notice: nil, alert: nil)
    @notice = notice
    @alert = alert
  end
end
