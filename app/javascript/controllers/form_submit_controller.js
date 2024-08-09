import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-submit"
export default class extends Controller {
  static values = {
    saveAndExit: Boolean
  }

  submitForm(event) {
    event.preventDefault()

    this.formToSubmit = document.getElementById("form-to-submit")

    if (this.saveAndExitValue) {
      this.addSaveAndExitInput()
    }
    this.formToSubmit.submit()
  }

  addSaveAndExitInput() {
    const input = document.createElement('input')
    input.type = 'hidden'
    input.name = 'save_and_exit'
    input.value = 'true'
    this.formToSubmit.appendChild(input)
  }
}