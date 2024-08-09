import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "content", "progressBar"]

  static values = {
    delay: Number
  }

  connect() {
    this.show()
  }

  show() {
    this.contentTarget.classList.remove('hide')
    this.animateProgressBar()
    this.timer = setTimeout(() => {
      this.hide()
    }, this.delayValue)
  }

  hide() {
    clearTimeout(this.timer)
    this.contentTarget.classList.add('hide')
    this.contentTarget.addEventListener('animationend', () => {
      this.containerTarget.remove()
    }, { once: true })
  }

  animateProgressBar() {
    if (this.hasProgressBarTarget) {
      // Set initial width to 100%
      this.progressBarTarget.style.width = '100%'

      // Use setTimeout to ensure the initial state is rendered
      setTimeout(() => {
        // Animate to 0% width
        this.progressBarTarget.style.width = '0%'
      }, 50)
    }
  }
}