// app/javascript/controllers/file_selector_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "filename", "supportedTypes"];

  connect() {
    // Bind the updateFileName method to the input change event
    this.inputTarget.addEventListener('change', () => this.updateFileName());
  }

  updateFileName() {
    const files = this.inputTarget.files;

    if (files.length > 0) {
      const filenames = Array.from(files).map(file => file.name).join(", ");
      this.filenameTarget.textContent = filenames;
    } else {
      this.filenameTarget.textContent = "400MB max file size.";
    }
  }
}
