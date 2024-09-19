// app/javascript/controllers/file_selector_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "filename", "supportedtypes"];

  updateFileName() {
    console.log("updateFileName", this.inputTarget.files, this.filenameTarget);
    
    const files = this.inputTarget.files;
    if (files.length > 0) {
      console.log("files", files);
      
      let filenames = Array.from(files).map(file => file.name).join(", ");
      console.log("filenames", filenames);
      
      this.filenameTarget.textContent = filenames;
      console.log("this.filenameTarget", this.filenameTarget);
      
    } else {
      this.filenameTarget.textContent = "400MB max file size.";
    }
  }
}
