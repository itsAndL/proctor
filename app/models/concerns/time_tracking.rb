module TimeTracking
  extend ActiveSupport::Concern

  included do
    before_save :set_timestamps
    after_find :set_completed_if_time_exceeded
  end

  def calculate_time_taken
    return -1 if infinite_time?

    (Time.current.to_i - (started_at || 0).to_i)
  end

  def infinite_time?
    duration_seconds.nil? || duration_seconds.zero?
  end

  def more_time?
    duration_seconds > calculate_time_taken
  end

  def duration_left
    return 0 if infinite_time?

    duration_seconds - calculate_time_taken
  end

  def total_time_taken
    return 0 if infinite_time? || started_at.nil? || completed_at.nil?

    (completed_at - started_at).to_i
  end

  private

  def set_completed_if_time_exceeded
    return if pending? || completed? || calculate_time_taken < duration_seconds

    completed!
  end

  def set_timestamps
    return unless status_changed?

    self.started_at = Time.current if started? && started_at.nil?
    self.completed_at = Time.current if completed? && completed_at.nil?
  end
end
