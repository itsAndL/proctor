export default class WebcamHandler {
  constructor(controller) {
    this.controller = controller
    this.webcamStream = null
    this.webcamCaptureInterval = null
  }

  async initializeWebcam(retryCount = 0) {
    try {
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        throw new Error('mediaDevices not supported');
      }

      let devices = await navigator.mediaDevices.enumerateDevices();
      let videoDevices = devices.filter(device => device.kind === 'videoinput');

      const selectedDeviceId = await this.selectCamera()
      if (!selectedDeviceId) {
        throw new Error('No camera selected');
      }

      // Re-enumerate devices after permissions have been granted
      devices = await navigator.mediaDevices.enumerateDevices();
      videoDevices = devices.filter(device => device.kind === 'videoinput');

      this.populateCameraSelect(videoDevices)
      await this.startWebcam(selectedDeviceId)

      if (this.controller.hasCameraSelectTarget) {
        this.controller.cameraSelectTarget.value = selectedDeviceId
      }
    } catch (error) {
      console.error('Webcam initialization error:', error);
      if (retryCount < 3) {
        console.warn(`Webcam initialization failed, retrying (${retryCount + 1}/3)...`);
        setTimeout(() => this.initializeWebcam(retryCount + 1), 1000);
      } else {
        this.controller.errorLogger.logError('webcam', error, { retryCount });
        this.showCameraError("Failed to initialize webcam after multiple attempts. Please check your camera settings and permissions.");
      }
    }
  }

  async selectCamera() {
    const devices = await navigator.mediaDevices.enumerateDevices()
    const videoDevices = devices.filter(device => device.kind === 'videoinput')

    if (videoDevices.length === 0) {
      console.error('No video devices found');
      this.showCameraError()
      return null
    }

    const storedCameraId = localStorage.getItem('selectedCameraId')
    let selectedDevice

    if (storedCameraId) {
      selectedDevice = videoDevices.find(device => device.deviceId === storedCameraId)
    }

    if (!selectedDevice) {
      if (/Mobile|Android|webOS|iPhone|iPad|iPod|BlackBerry|Windows Phone/i.test(navigator.userAgent)) {
        selectedDevice = videoDevices.find(device => device.label.toLowerCase().includes('front')) || videoDevices[0]
      } else {
        selectedDevice = videoDevices[0]
      }
    }

    // If the deviceId is empty, we need to request permissions first
    if (!selectedDevice.deviceId) {
      try {
        const stream = await navigator.mediaDevices.getUserMedia({ video: true });
        stream.getTracks().forEach(track => track.stop()); // Stop the stream immediately

        // Re-enumerate devices after getting permissions
        const updatedDevices = await navigator.mediaDevices.enumerateDevices();
        const updatedVideoDevices = updatedDevices.filter(device => device.kind === 'videoinput');
        selectedDevice = updatedVideoDevices[0];
      } catch (error) {
        console.error('Error requesting camera permissions:', error);
        this.showCameraError('Failed to get camera permissions. Please allow camera access and try again.');
        return null;
      }
    }

    return selectedDevice.deviceId;
  }

  populateCameraSelect(videoDevices) {
    if (!this.controller.hasCameraSelectTarget) return

    this.controller.cameraSelectTarget.innerHTML = videoDevices.map(device =>
      `<option value="${device.deviceId}">${device.label || `Camera ${device.deviceId.slice(0, 5)}`}</option>`
    ).join('')

    this.controller.cameraSelectTarget.addEventListener('change', this.handleCameraChange.bind(this))
  }

  async startWebcam(deviceId) {
    try {
      const constraints = {
        video: { deviceId: { exact: deviceId } }
      };
      this.webcamStream = await navigator.mediaDevices.getUserMedia(constraints);

      if (this.controller.hasCameraStreamTarget) {
        this.controller.cameraStreamTarget.srcObject = this.webcamStream;
        this.controller.cameraStreamTarget.onloadedmetadata = () => {
          this.controller.cameraStreamTarget.play();
          this.hideCameraError();
        };
        this.controller.cameraStreamTarget.onerror = (event) => {
          console.error('Camera stream error:', event);
          this.controller.errorLogger.logError('webcam', new Error('Camera stream error'), { event });
          this.showCameraError('An error occurred with the camera stream. Attempting to reconnect...');
          this.handleWebcamEnded();
        };
        // Add event listener for unexpected stream end
        this.webcamStream.getVideoTracks()[0].addEventListener('ended', this.handleWebcamEnded.bind(this));
      }
      this.reportWebcamStatus(true)
    } catch (error) {
      console.error('Error starting webcam:', error);
      this.controller.errorLogger.logError('webcam', error, { deviceId });
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
    if (this.controller.hasCameraErrorTarget) {
      this.controller.cameraErrorTarget.classList.remove('hidden');
      console.warn(message);
    }
    if (this.controller.hasCameraStreamTarget) {
      this.controller.cameraStreamTarget.classList.add('hidden');
    }
    this.reportWebcamStatus(false)
  }

  hideCameraError() {
    if (this.controller.hasCameraErrorTarget) {
      this.controller.cameraErrorTarget.classList.add('hidden')
    }
    if (this.controller.hasCameraStreamTarget) {
      this.controller.cameraStreamTarget.classList.remove('hidden')
    }
    this.reportWebcamStatus(true)
  }

  async startPeriodicWebcamCapture() {
    // Ensure webcam is initialized
    if (!this.webcamStream || !this.webcamStream.active) {
      await this.initializeWebcam();
    }

    // Report webcam status
    if (this.webcamStream && this.webcamStream.active) {
      this.reportWebcamStatus(true);
    } else {
      this.reportWebcamStatus(false);
    }

    // Capture image immediately and wait for it to complete
    try {
      await this.captureWebcamImage();
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
      if (this.webcamStream && this.webcamStream.active) {
        const videoTrack = this.webcamStream.getVideoTracks()[0];

        if (!videoTrack || !videoTrack.enabled) {
          console.warn('Video track is not available or not enabled');
          this.reportWebcamStatus(false)
          return;
        }

        const video = document.createElement('video');
        video.srcObject = this.webcamStream;
        video.play();

        video.onloadedmetadata = () => {
          const canvas = document.createElement('canvas');
          canvas.width = video.videoWidth;
          canvas.height = video.videoHeight;
          canvas.getContext('2d').drawImage(video, 0, 0);
          const imageDataUrl = canvas.toDataURL('image/jpeg');
          this.controller.updateSender.debouncedSendUpdate({ webcam_image: imageDataUrl });
          video.pause();
          video.srcObject = null;
          this.reportWebcamStatus(true);
          resolve();
        };

        video.onerror = (error) => {
          console.error('Error occurred while setting up video for capture:', error);
          this.controller.errorLogger.logError('webcam', error, { context: 'image capture' });
          reject(error);
        };
      } else {
        console.warn('Webcam stream not available for capture');
        this.reportWebcamStatus(false)

        // Attempt to reinitialize the webcam
        this.initializeWebcam().then(resolve).catch(reject);
      }
    });
  }

  reportWebcamStatus(isEnabled) {
    if (this.controller.reportWebcamValue) {
      this.controller.updateSender.debouncedSendUpdate({ webcam_enabled: isEnabled });
    }
  }

  disconnect() {
    if (this.webcamStream) {
      this.webcamStream.getTracks().forEach(track => track.stop());
    }
    if (this.webcamCaptureInterval) {
      clearInterval(this.webcamCaptureInterval);
    }
  }
}
