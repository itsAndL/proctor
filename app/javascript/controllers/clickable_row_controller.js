import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clickable-row"
export default class extends Controller {
  static values = { url: String }

  handleClick(event) {
    // Don't navigate if the click was on or inside the dropdown
    if (event.target.closest('.ignore')) return

    // Navigate to the URL
    window.location.href = this.urlValue
  }
}