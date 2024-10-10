export default class MouseTracker {
  constructor(controller) {
    this.controller = controller
    this.handleMouseLeave = this.handleMouseLeave.bind(this)
    this.handleMouseEnter = this.handleMouseEnter.bind(this)
  }

  startTracking() {
    this.controller.updateSender.debouncedSendUpdate({ mouse_left_window: false });
    document.addEventListener('mouseleave', this.handleMouseLeave);
    document.addEventListener('mouseenter', this.handleMouseEnter);
  }

  handleMouseLeave() {
    this.controller.updateSender.bufferStateChange('mouse_left_window', true);
  }

  handleMouseEnter() {
    clearTimeout(this.controller.updateSender.mouse_left_windowTimer);
    this.controller.updateSender.debouncedSendUpdate({ mouse_left_window: false });
  }

  disconnect() {
    document.removeEventListener('mouseleave', this.handleMouseLeave);
    document.removeEventListener('mouseenter', this.handleMouseEnter);
  }
}
