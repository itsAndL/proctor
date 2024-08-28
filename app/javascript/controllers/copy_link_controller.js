import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text"]
  static values = { link: String }

  copy() {
    navigator.clipboard.writeText(this.linkValue).then(() => {
      const originalText = this.textTarget.textContent
      this.textTarget.textContent = "Copied!"
      setTimeout(() => {
        this.textTarget.textContent = originalText
      }, 2000)
    }).catch(err => {
      console.error('Failed to copy: ', err)
    })
  }
}