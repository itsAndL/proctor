module Monitorable
  extend ActiveSupport::Concern

  def add_device(device_type)
    return if devices&.include?(device_type)

    self.devices = (devices || []) << device_type
    save
  end

  def add_location(location)
    return if locations&.include?(location)

    self.locations = (locations || []) << location
    save
  end

  def add_ip(ip)
    return if ips&.include?(ip)

    self.ips = (ips || []) << ip
    save
  end

  def update_monitoring_data(data)
    self.webcam_enabled = data[:webcam_enabled] if data.key?(:webcam_enabled) && (webcam_enabled.nil? || webcam_enabled)
    self.fullscreen_always_active = !data[:fullscreen_exited] if data.key?(:fullscreen_exited) && (fullscreen_always_active.nil? || fullscreen_always_active)
    self.mouse_always_in_window = !data[:mouse_left_window] if data.key?(:mouse_left_window) && (mouse_always_in_window.nil? || mouse_always_in_window)

    add_device(data[:device]) if data[:device]
    add_location(data[:location]) if data[:location]
    add_ip(data[:ip]) if data[:ip]

    save_screenshot(data[:webcam_image]) if data[:webcam_image]

    save
  end

  private

  def save_screenshot(webcam_image)
    return unless webcam_image.present?

    screenshots.create do |screenshot|
      screenshot.image.attach(
        io: StringIO.new(Base64.decode64(webcam_image.split(',').last)),
        filename: "screenshot_#{Time.current.to_i}.png",
        content_type: 'image/png'
      )
    end
  end
end
