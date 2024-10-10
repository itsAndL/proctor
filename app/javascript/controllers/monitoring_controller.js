import { Controller } from "@hotwired/stimulus"
import WebcamHandler from './monitoring/webcam_handler'
import DeviceTracker from './monitoring/device_tracker'
import LocationTracker from './monitoring/location_tracker'
import FullscreenTracker from './monitoring/fullscreen_tracker'
import MouseTracker from './monitoring/mouse_tracker'
import ErrorLogger from './monitoring/error_logger'
import UpdateSender from './monitoring/update_sender'

export default class extends Controller {
  static targets = ["cameraSelect", "cameraStream", "cameraError"]
  static values = {
    fullscreen: { type: Boolean, default: false },
    webcam: { type: Boolean, default: false },
    device: { type: Boolean, default: false },
    location: { type: Boolean, default: false },
    ip: { type: Boolean, default: false },
    periodicWebcamCapture: { type: Boolean, default: false },
    trackFullscreen: { type: Boolean, default: false },
    trackMouse: { type: Boolean, default: false },
    reportWebcam: { type: Boolean, default: true },
    assessmentParticipationHashId: String
  }

  initialize() {
    this.updateSender = new UpdateSender(this)
    this.errorLogger = new ErrorLogger(this)
    this.webcamHandler = new WebcamHandler(this)
    this.deviceTracker = new DeviceTracker(this)
    this.locationTracker = new LocationTracker(this)
    this.fullscreenTracker = new FullscreenTracker(this)
    this.mouseTracker = new MouseTracker(this)
  }

  connect() {
    this.fullscreenTracker.toggleFullscreen(this.fullscreenValue)
    if (this.webcamValue) this.webcamHandler.initializeWebcam()
    if (this.deviceValue) this.deviceTracker.trackDevice()
    if (this.locationValue) this.locationTracker.trackLocation()
    if (this.ipValue) this.locationTracker.trackIp()
    if (this.periodicWebcamCaptureValue) this.webcamHandler.startPeriodicWebcamCapture()
    if (this.trackFullscreenValue) this.fullscreenTracker.startTracking()
    if (this.trackMouseValue) this.mouseTracker.startTracking()
  }

  disconnect() {
    this.webcamHandler.disconnect()
    this.fullscreenTracker.disconnect()
    this.mouseTracker.disconnect()
  }
}
