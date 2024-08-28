import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="copy"
export default class extends Controller {
  static targets = ["source", "button"]
  static values = { active: Boolean }

  connect() {
    this.updateButtonState()
  }

  copy(event) {
    event.preventDefault()
    if (!this.activeValue) return

    const textToCopy = this.sourceTarget.dataset.copyText || this.sourceTarget.value
    const clickedButton = event.currentTarget

    navigator.clipboard.writeText(textToCopy).then(() => {
      this.showCopiedFeedback(clickedButton)
    })
  }

  showCopiedFeedback(button) {
    const originalText = button.innerHTML
    button.innerHTML = "Copied!"
    setTimeout(() => {
      button.innerHTML = originalText
    }, 2000)
  }

  updateButtonState() {
    this.buttonTargets.forEach(button => {
      button.disabled = !this.activeValue
    })
  }

  activeValueChanged() {
    this.updateButtonState()
  }
}