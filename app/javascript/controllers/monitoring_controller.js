import { Controller } from "@hotwired/stimulus"

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

  connect() {
    if (this.fullscreenValue) {
      this.enterFullscreen()
    } else {
      this.exitFullscreen()
    }
    if (this.webcamValue) this.initializeWebcam()
    if (this.deviceValue) this.trackDevice()
    if (this.locationValue) this.trackLocation()
    if (this.ipValue) this.trackIp()
    if (this.periodicWebcamCaptureValue) this.startPeriodicWebcamCapture()
    if (this.trackFullscreenValue) this.startTrackingFullscreen()
    if (this.trackMouseValue) this.startTrackingMouse()
  }

  disconnect() {
    if (this.webcamStream) {
      this.webcamStream.getTracks().forEach(track => track.stop());
    }
    if (this.webcamCaptureInterval) {
      clearInterval(this.webcamCaptureInterval);
    }
    document.removeEventListener('fullscreenchange', this.handleFullscreenChange);
    document.removeEventListener('mouseleave', this.handleMouseLeave);
    document.removeEventListener('mouseenter', this.handleMouseEnter);
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

  bufferStateChange(stateKey, newValue, bufferTime = 2000) {
    clearTimeout(this[`${stateKey}Timer`]);
    this[`${stateKey}Timer`] = setTimeout(() => {
      this.debouncedSendUpdate({ [stateKey]: newValue });
    }, bufferTime);
  }

  handleFullscreenChange() {
    const isFullscreen = !!document.fullscreenElement;
    this.bufferStateChange('fullscreen_exited', !isFullscreen);
  }

  async initializeWebcam(retryCount = 0) {
    console.log('Initializing webcam...');
    try {
      console.log('Checking mediaDevices support...');
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        throw new Error('mediaDevices not supported');
      }

      console.log('Enumerating devices...');
      let devices = await navigator.mediaDevices.enumerateDevices();
      console.log('All devices:', devices);

      let videoDevices = devices.filter(device => device.kind === 'videoinput');
      console.log('Video devices:', videoDevices);

      const selectedDeviceId = await this.selectCamera()
      if (!selectedDeviceId) {
        throw new Error('No camera selected');
      }
      console.log('Selected device ID:', selectedDeviceId);

      // Re-enumerate devices after permissions have been granted
      devices = await navigator.mediaDevices.enumerateDevices();
      videoDevices = devices.filter(device => device.kind === 'videoinput');
      console.log('Updated video devices:', videoDevices);

      this.populateCameraSelect(videoDevices)
      await this.startWebcam(selectedDeviceId)

      if (this.hasCameraSelectTarget) {
        this.cameraSelectTarget.value = selectedDeviceId
      }
    } catch (error) {
      console.error('Webcam initialization error:', error);
      if (retryCount < 3) {
        console.warn(`Webcam initialization failed, retrying (${retryCount + 1}/3)...`);
        setTimeout(() => this.initializeWebcam(retryCount + 1), 1000);
      } else {
        this.logError('webcam', error, { retryCount });
        this.showCameraError("Failed to initialize webcam after multiple attempts. Please check your camera settings and permissions.");
      }
    }
  }

  async selectCamera() {
    console.log('Selecting camera...');
    const devices = await navigator.mediaDevices.enumerateDevices()
    const videoDevices = devices.filter(device => device.kind === 'videoinput')
    console.log('Available video devices:', videoDevices);

    if (videoDevices.length === 0) {
      console.error('No video devices found');
      this.showCameraError()
      return null
    }

    const storedCameraId = localStorage.getItem('selectedCameraId')
    let selectedDevice

    if (storedCameraId) {
      selectedDevice = videoDevices.find(device => device.deviceId === storedCameraId)
      console.log('Stored camera found:', selectedDevice);
    }

    if (!selectedDevice) {
      if (/Mobile|Android|webOS|iPhone|iPad|iPod|BlackBerry|Windows Phone/i.test(navigator.userAgent)) {
        selectedDevice = videoDevices.find(device => device.label.toLowerCase().includes('front')) || videoDevices[0]
      } else {
        selectedDevice = videoDevices[0]
      }
      console.log('Selected default camera:', selectedDevice);
    }

    // If the deviceId is empty, we need to request permissions first
    if (!selectedDevice.deviceId) {
      console.log('Empty deviceId, requesting permissions...');
      try {
        const stream = await navigator.mediaDevices.getUserMedia({ video: true });
        stream.getTracks().forEach(track => track.stop()); // Stop the stream immediately
        // Re-enumerate devices after getting permissions
        const updatedDevices = await navigator.mediaDevices.enumerateDevices();
        const updatedVideoDevices = updatedDevices.filter(device => device.kind === 'videoinput');
        selectedDevice = updatedVideoDevices[0];
        console.log('Updated selected device after permissions:', selectedDevice);
      } catch (error) {
        console.error('Error requesting camera permissions:', error);
        this.showCameraError('Failed to get camera permissions. Please allow camera access and try again.');
        return null;
      }
    }

    return selectedDevice.deviceId;
  }

  populateCameraSelect(videoDevices) {
    if (!this.hasCameraSelectTarget) return

    console.log('Populating camera select with devices:', videoDevices);

    this.cameraSelectTarget.innerHTML = videoDevices.map(device =>
      `<option value="${device.deviceId}">${device.label || `Camera ${device.deviceId.slice(0, 5)}`}</option>`
    ).join('')

    console.log('Camera select populated:', this.cameraSelectTarget.innerHTML);

    this.cameraSelectTarget.addEventListener('change', this.handleCameraChange.bind(this))
  }

  async startWebcam(deviceId) {
    console.log('Starting webcam with device ID:', deviceId);
    try {
      const constraints = {
        video: { deviceId: { exact: deviceId } }
      };
      console.log('Using constraints:', constraints);
      this.webcamStream = await navigator.mediaDevices.getUserMedia(constraints);
      console.log('Webcam stream obtained:', this.webcamStream);

      if (this.hasCameraStreamTarget) {
        this.cameraStreamTarget.srcObject = this.webcamStream;
        this.cameraStreamTarget.onloadedmetadata = () => {
          console.log('Camera stream metadata loaded');
          this.cameraStreamTarget.play();
          this.hideCameraError();
        };
        this.cameraStreamTarget.onerror = (event) => {
          console.error('Camera stream error:', event);
          this.logError('webcam', new Error('Camera stream error'), { event });
          this.showCameraError('An error occurred with the camera stream. Attempting to reconnect...');
          this.handleWebcamEnded();
        };
        // Add event listener for unexpected stream end
        this.webcamStream.getVideoTracks()[0].addEventListener('ended', this.handleWebcamEnded.bind(this));
      }
      if (this.reportWebcamValue) {
        this.debouncedSendUpdate({ webcam_enabled: true });
      }
    } catch (error) {
      console.error('Error starting webcam:', error);
      this.logError('webcam', error, { deviceId });
      this.showCameraError('Failed to start the webcam. Please check your camera settings and permissions.');
      // Attempt to reconnect after a short delay
      setTimeout(() => this.handleWebcamEnded(), 3000);
    }
  }

  handleWebcamEnded() {
    console.warn("Webcam stream ended unexpectedly. Attempting to reconnect...")
    this.initializeWebcam()
  }

  async handleCameraChange(event) {
    const newDeviceId = event.target.value
    localStorage.setItem('selectedCameraId', newDeviceId)
    if (this.webcamStream) {
      this.webcamStream.getTracks().forEach(track => track.stop())
    }
    await this.startWebcam(newDeviceId)
  }

  showCameraError(message = "Camera access is required for this assessment. Please enable your camera and refresh the page.") {
    if (this.hasCameraErrorTarget) {
      this.cameraErrorTarget.classList.remove('hidden');
      console.warn(message);
    }
    if (this.hasCameraStreamTarget) {
      this.cameraStreamTarget.classList.add('hidden');
    }
    if (this.reportWebcamValue) {
      this.debouncedSendUpdate({ webcam_enabled: false });
    }
  }

  hideCameraError() {
    if (this.hasCameraErrorTarget) {
      this.cameraErrorTarget.classList.add('hidden')
    }
    if (this.hasCameraStreamTarget) {
      this.cameraStreamTarget.classList.remove('hidden')
    }
  }

  async startPeriodicWebcamCapture() {
    console.log('Starting periodic webcam capture...');

    // Ensure webcam is initialized
    if (!this.webcamStream || !this.webcamStream.active) {
      console.log('Webcam not ready, initializing...');
      await this.initializeWebcam();
    }

    // Capture image immediately and wait for it to complete
    try {
      console.log('Capturing initial image...');
      await this.captureWebcamImage();
      console.log('Initial image captured successfully');
    } catch (error) {
      console.error('Failed to capture initial image:', error);
    }

    // Function to set a random interval
    const setRandomInterval = () => {
      // Generate a random number between 20000 and 30000 milliseconds (20 to 30 seconds)
      const randomInterval = Math.floor(Math.random() * (30000 - 20000 + 1) + 20000);

      // Clear any existing interval
      if (this.webcamCaptureInterval) {
        clearTimeout(this.webcamCaptureInterval);
      }

      // Set a new timeout with the random interval
      this.webcamCaptureInterval = setTimeout(async () => {
        try {
          await this.captureWebcamImage();
          console.log('Periodic image captured successfully');
        } catch (error) {
          console.error('Failed to capture periodic image:', error);
        }
        setRandomInterval(); // Set the next interval after capturing
      }, randomInterval);
    };

    // Start the random interval process
    setRandomInterval();
  }

  captureWebcamImage() {
    return new Promise((resolve, reject) => {
      console.log('Attempting to capture webcam image...');
      console.log('Webcam stream:', this.webcamStream);
      console.log('Webcam stream active:', this.webcamStream && this.webcamStream.active);

      if (this.webcamStream && this.webcamStream.active) {
        const videoTrack = this.webcamStream.getVideoTracks()[0];
        console.log('Video track:', videoTrack);
        console.log('Video track enabled:', videoTrack && videoTrack.enabled);

        if (!videoTrack || !videoTrack.enabled) {
          console.warn('Video track is not available or not enabled');
          if (this.reportWebcamValue) {
            this.debouncedSendUpdate({ webcam_enabled: false });
          }
          return;
        }

        const video = document.createElement('video');
        video.srcObject = this.webcamStream;
        video.play();

        video.onloadedmetadata = () => {
          console.log('Video metadata loaded, attempting to capture frame...');
          const canvas = document.createElement('canvas');
          canvas.width = video.videoWidth;
          canvas.height = video.videoHeight;
          canvas.getContext('2d').drawImage(video, 0, 0);
          const imageDataUrl = canvas.toDataURL('image/jpeg');
          this.debouncedSendUpdate({ webcam_image: imageDataUrl });
          video.pause();
          video.srcObject = null;
          console.log('Webcam image captured and sent');
          resolve();
        };

        video.onerror = (error) => {
          console.error('Error occurred while setting up video for capture:', error);
          this.logError('webcam', error, { context: 'image capture' });
          reject(error);
        };
      } else {
        console.warn('Webcam stream not available for capture');
        if (this.reportWebcamValue) {
          this.debouncedSendUpdate({ webcam_enabled: false });
        }

        // Attempt to reinitialize the webcam
        console.log('Attempting to reinitialize webcam...');
        this.initializeWebcam().then(resolve).catch(reject);
      }
    });
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
    this.debouncedSendUpdate({ mouse_left_window: false });
    document.addEventListener('mouseleave', this.handleMouseLeave.bind(this));
    document.addEventListener('mouseenter', this.handleMouseEnter.bind(this));
  }

  handleMouseLeave() {
    this.bufferStateChange('mouse_left_window', true);
  }

  handleMouseEnter() {
    clearTimeout(this.mouse_left_windowTimer);
    // Optionally, you can reset the state immediately
    this.debouncedSendUpdate({ mouse_left_window: false });
  }

  logError(feature, error, context = {}) {
    console.error(`[${feature}] Error:`, error, 'Context:', context);
    // You could also send this error to your server for logging
    this.debouncedSendUpdate({ error_log: { feature, error: error.message, context } });
  }

  initialize() {
    this.debouncedSendUpdate = debounce(this.sendUpdate.bind(this), 300);
  }

  sendUpdate(data) {
    const url = `/api/monitoring/${this.assessmentParticipationHashIdValue}`;
    fetch(url, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify(data)
    });
  }
}

function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}