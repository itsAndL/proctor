import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bulk-invite"
export default class extends Controller {
  static targets = ["form", "fileInput", "submitButton", "fileInfo", "fileName"]

  connect() {
    this.updateSubmitButton()
  }

  triggerFileInput(event) {
    // Check if the clicked element is the formTarget or a descendant of formTarget
    if (this.formTarget.contains(event.target)) {
      this.fileInputTarget.click()
    }
  }

  preventDefault(event) {
    event.preventDefault()
    event.stopPropagation()
  }

  handleDrop(event) {
    this.preventDefault(event)
    const file = event.dataTransfer.files[0]
    this.handleFile(file)
  }

  handleFileSelect(event) {
    const file = event.target.files[0]
    this.handleFile(file)
  }

  handleFile(file) {
    if (file) {
      // Create a new FileList containing only the selected file
      const dataTransfer = new DataTransfer()
      dataTransfer.items.add(file)
      this.fileInputTarget.files = dataTransfer.files

      this.fileNameTarget.textContent = file.name
      this.fileInfoTarget.classList.remove('hidden')
      this.formTarget.classList.add('bg-zinc-100')

      setTimeout(() => {
        this.formTarget.classList.remove('bg-zinc-100')
      }, 1000)

      this.updateSubmitButton()
    }
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
  }
}