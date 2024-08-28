import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bulk-invite"
export default class extends Controller {
  static targets = ["form", "fileInput", "submitButton"]

  connect() {
    this.updateSubmitButton()
  }

  updateSubmitButton() {
    if (this.hasFileInputTarget && this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = !this.fileInputTarget.files.length
    }
  }

  submitForm(event) {
    event.preventDefault()
    if (this.hasFileInputTarget && this.fileInputTarget.files.length) {
      this.formTarget.requestSubmit()
    } else {
      alert("Please select a file to upload.")
    }
    q
  }
}