import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="slider"
export default class extends Controller {
  next({ params: { slide } }) {
    // Hide the current slide
    document.getElementById(`slide-${slide}`).classList.add("hidden")

    // show the next slide
    document.getElementById(`slide-${slide + 1}`).classList.remove("hidden")
  }

  back({ params: { slide } }) {
    // Hide the current slide
    document.getElementById(`slide-${slide}`).classList.add("hidden")

    // show the previous slide
    document.getElementById(`slide-${slide - 1}`).classList.remove("hidden")
  }
}
