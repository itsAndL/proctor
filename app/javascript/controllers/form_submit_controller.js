import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-submit"
export default class extends Controller {
  static targets = ["hiddenSubmit"]

  submitForm(event) {
    event.preventDefault()
    this.hiddenSubmitTarget.click()
  }
}