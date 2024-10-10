export default class DeviceTracker {
  constructor(controller) {
    this.controller = controller
  }

  trackDevice() {
    const deviceType = this.determineDeviceType(navigator.userAgent)
    this.controller.updateSender.sendUpdate({ device: deviceType })
  }

  determineDeviceType(userAgent) {
    if (/Mobile|Android|webOS|iPhone|iPad|iPod|BlackBerry|Windows Phone/i.test(userAgent)) {
      return "Mobile"
    }
    return "Desktop"
  }
}
