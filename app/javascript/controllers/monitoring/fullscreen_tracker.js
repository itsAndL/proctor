export default class FullscreenTracker {
  constructor(controller) {
    this.controller = controller
    this.handleFullscreenChange = this.handleFullscreenChange.bind(this)
  }

  toggleFullscreen(shouldBeFullscreen) {
    if (shouldBeFullscreen) {
      // Attempt to enable fullscreen
      if (!document.fullscreenElement) {
        document.documentElement.requestFullscreen().catch((err) => {
          console.error(`Error attempting to enable fullscreen: ${err.message}`);
        });
      }
    } else {
      // Attempt to exit fullscreen
      if (document.fullscreenElement) {
        document.exitFullscreen().catch((err) => {
          console.error(`Error attempting to exit fullscreen: ${err.message}`);
        });
      }
    }
  }

  startTracking() {
    this.controller.updateSender.sendUpdate({ fullscreen_exited: false })
    document.addEventListener('fullscreenchange', this.handleFullscreenChange)
  }

  handleFullscreenChange() {
    const isFullscreen = !!document.fullscreenElement;
    this.controller.updateSender.bufferStateChange('fullscreen_exited', !isFullscreen);
  }

  disconnect() {
    document.removeEventListener('fullscreenchange', this.handleFullscreenChange);
  }
}
