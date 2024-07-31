import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="assessment-title"
export default class extends Controller {
  static targets = ["input", "display"]

  connect() {
    this.updateTitle()
  }

  updateTitle() {
    const title = this.inputTarget.value.trim()
    this.displayTarget.textContent = title || "Untitled assessment"
  }
}