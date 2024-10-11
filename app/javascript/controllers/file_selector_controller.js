import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "filename", "supportedTypes"];
  
  connect() {
    // Bind the updateFileName method to the input change event
    this.inputTarget.addEventListener('change', () => this.updateFileName());
    this.inputTarget.addEventListener('click', () => this.ensureFullScreen());
  }

  updateFileName() {
    const files = this.inputTarget.files;

    if (files.length > 0) {
      const filenames = Array.from(files).map(file => file.name).join(", ");
      this.filenameTarget.textContent = filenames;
    } else {
      this.filenameTarget.textContent = I18n.file_selector_controller.max_file_size;
    }

    // Ensure full-screen mode after file selection
    this.ensureFullScreen();
  }

  ensureFullScreen() {
    if (!document.fullscreenElement) {
      this.enterFullScreen();
    }
  }

  enterFullScreen() {
    if (document.documentElement.requestFullscreen) {
      document.documentElement.requestFullscreen();
    } else if (document.documentElement.mozRequestFullScreen) { // Firefox
      document.documentElement.mozRequestFullScreen();
    } else if (document.documentElement.webkitRequestFullscreen) { // Chrome, Safari and Opera
      document.documentElement.webkitRequestFullscreen();
    } else if (document.documentElement.msRequestFullscreen) { // IE/Edge
      document.documentElement.msRequestFullscreen();
    }
  }
}
