import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["form", "input", "radio", "checkbox", "select"]

  connect() {
    this.timeout = null
  }

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit()
    }, 300)
  }

  submitOnCheck() {
    this.formTarget.requestSubmit()
  }

  submitOnChange() {
    this.formTarget.requestSubmit()
  }
}
