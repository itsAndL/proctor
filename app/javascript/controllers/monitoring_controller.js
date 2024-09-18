import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    fullscreen: { type: Boolean, default: false },
    webcam: { type: Boolean, default: false },
    device: { type: Boolean, default: false },
    location: { type: Boolean, default: false },
    ip: { type: Boolean, default: false },
    periodicWebcamCapture: { type: Boolean, default: false },
    trackFullscreen: { type: Boolean, default: false },
    trackMouse: { type: Boolean, default: false },
    assessmentParticipationId: String
  }

  connect() {
    if (this.fullscreenValue) {
      this.enterFullscreen()
    } else {
      this.exitFullscreen()
    }
    if (this.webcamValue) this.startWebcam()
    if (this.deviceValue) this.trackDevice()
    if (this.locationValue) this.trackLocation()
    if (this.ipValue) this.trackIp()
    if (this.periodicWebcamCaptureValue) this.startPeriodicWebcamCapture()
    if (this.trackFullscreenValue) this.startTrackingFullscreen()
    if (this.trackMouseValue) this.startTrackingMouse()
  }

  disconnect() {
    if (this.webcamStream) {
      this.webcamStream.getTracks().forEach(track => track.stop())
    }
    if (this.webcamCaptureInterval) {
      clearInterval(this.webcamCaptureInterval)
    }
    document.removeEventListener('fullscreenchange', this.handleFullscreenChange)
    document.removeEventListener('mouseleave', this.handleMouseLeave)
  }

  enterFullscreen() {
    if (!document.fullscreenElement) {
      document.documentElement.requestFullscreen()
    }
  }

  exitFullscreen() {
    if (document.fullscreenElement) {
      document.exitFullscreen()
    }
  }

  handleFullscreenChange() {
    if (!document.fullscreenElement) {
      this.sendUpdate({ fullscreen_exited: true })
    }
  }

  startWebcam() {
    navigator.mediaDevices.getUserMedia({ video: true })
      .then(stream => {
        this.webcamStream = stream
        this.sendUpdate({ webcam_enabled: true })
      })
      .catch(() => this.sendUpdate({ webcam_enabled: false }))
  }

  startPeriodicWebcamCapture() {
    // Capture image immediately
    this.captureWebcamImage()

    // Function to set a random interval
    const setRandomInterval = () => {
      // Generate a random number between 20000 and 30000 milliseconds (20 to 30 seconds)
      const randomInterval = Math.floor(Math.random() * (30000 - 20000 + 1) + 20000)

      // Clear any existing interval
      if (this.webcamCaptureInterval) {
        clearTimeout(this.webcamCaptureInterval)
      }

      // Set a new timeout with the random interval
      this.webcamCaptureInterval = setTimeout(() => {
        this.captureWebcamImage()
        setRandomInterval() // Set the next interval after capturing
      }, randomInterval)
    }

    // Start the random interval process
    setRandomInterval()
  }

  captureWebcamImage() {
    if (this.webcamStream) {
      const video = document.createElement('video')
      video.srcObject = this.webcamStream
      video.play()

      video.onloadedmetadata = () => {
        const canvas = document.createElement('canvas')
        canvas.width = video.videoWidth
        canvas.height = video.videoHeight
        canvas.getContext('2d').drawImage(video, 0, 0)
        const imageDataUrl = canvas.toDataURL('image/jpeg')
        this.sendUpdate({ webcam_image: imageDataUrl })
        video.pause()
        video.srcObject = null
      }
    } else {
      this.sendUpdate({ webcam_enabled: false })
    }
  }

  trackDevice() {
    const deviceType = this.determineDeviceType(navigator.userAgent)
    this.sendUpdate({ device: deviceType })
  }

  trackLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        position => {
          this.getLocationName(position.coords.latitude, position.coords.longitude)
            .then(locationName => this.sendUpdate({ location: locationName }))
        },
        () => this.sendUpdate({ location_error: 'Unable to retrieve location' })
      )
    }
  }

  determineDeviceType(userAgent) {
    if (/Mobile|Android|webOS|iPhone|iPad|iPod|BlackBerry|Windows Phone/i.test(userAgent)) {
      return "Mobile"
    }
    return "Desktop"
  }

  async getLocationName(latitude, longitude) {
    try {
      const response = await fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitude}`);
      const data = await response.json();
      const city = data.address.city || data.address.town || data.address.village || 'Unknown City';
      const state = data.address.state;
      const country = data.address.country || 'Unknown Country';

      if (state) {
        return `${city}, ${state}, ${country}`;
      } else {
        return `${city}, ${country}`;
      }
    } catch (error) {
      console.error('Error getting location name:', error);
      return 'Unknown Location';
    }
  }

  trackIp() {
    fetch('https://api.ipify.org?format=json')
      .then(response => response.json())
      .then(data => this.sendUpdate({ ip: data.ip }))
  }

  startTrackingFullscreen() {
    this.sendUpdate({ fullscreen_exited: false })
    document.addEventListener('fullscreenchange', this.handleFullscreenChange.bind(this))
  }

  startTrackingMouse() {
    this.sendUpdate({ mouse_left_window: false })
    document.addEventListener('mouseleave', this.handleMouseLeave.bind(this))
  }

  handleMouseLeave() {
    this.sendUpdate({ mouse_left_window: true })
  }

  sendUpdate(data) {
    const url = `/api/monitoring/${this.assessmentParticipationIdValue}`
    fetch(url, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify(data)
    })
  }
}
