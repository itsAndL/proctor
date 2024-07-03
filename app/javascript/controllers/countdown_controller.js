import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="countdown"
export default class extends Controller {
  static targets = ["timer", "nextPage"]

  connect() {
    this.delayValue = parseInt(this.timerTarget.textContent)
    this.countdown()
  }

  countdown() {
    if (this.delayValue > 0) {
      this.timerTarget.textContent = this.delayValue
      this.delayValue--
      setTimeout(() => this.countdown(), 1000)
    } else {
      this.timerTarget.textContent = "0"
      // Add any code you want to run when the countdown finishes

      setTimeout(() => {
        this.nextPageTarget.click()
      }, this.delayValue * 1000)
    }
  }
}