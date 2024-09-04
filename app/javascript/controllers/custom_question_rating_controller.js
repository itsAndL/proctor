import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="custom-question-rating"
export default class extends Controller {
  static targets = ["star", "ratingInput"]
  static values = {
    initialRating: Number
  }

  connect() {
    const initialRating = this.initialRatingValue || this.ratingInputTarget.value || 0
    this.updateStars(parseInt(initialRating))
  }

  setRating(event) {
    const clickedRating = parseInt(event.currentTarget.dataset.rating)
    const currentRating = parseInt(this.ratingInputTarget.value) || 0

    if (clickedRating === currentRating) {
      // Deactivate all stars and set rating to nil
      this.updateStars(0)
      this.ratingInputTarget.value = ''
    } else {
      // Set new rating
      this.updateStars(clickedRating)
      this.ratingInputTarget.value = clickedRating
    }
  }

  updateStars(rating) {
    this.starTargets.forEach((star, index) => {
      if (index < rating) {
        star.classList.add("text-yellow-400")
        star.classList.remove("text-gray-200")
      } else {
        star.classList.add("text-gray-200")
        star.classList.remove("text-yellow-400")
      }
    })
  }
}