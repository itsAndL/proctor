import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clickable-row"
export default class extends Controller {
  connect() {
    this.add_event_listener(this.element)
  }

  add_event_listener(element) {
    element.addEventListener("click", (event) => {
      event.preventDefault()
      Turbo.visit(element.dataset.url)
    })
  }
}
