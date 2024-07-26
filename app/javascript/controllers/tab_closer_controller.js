import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tab-closer"
export default class extends Controller {
  close() {
    window.close()
  }
}
