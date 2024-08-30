import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="candidate-rating"
export default class extends Controller {
  static targets = ["star", "notes"]
  static values = {
    url: String,
    assessmentParticipationId: Number,
    initialRating: Number
  }

  connect() {
    this.updateStars(this.initialRatingValue)
    this.debounceTimer = null
  }

  setRating(event) {
    const rating = parseInt(event.currentTarget.dataset.rating)
    this.updateStars(rating)
    this.saveRating(rating)
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

  async saveRating(rating) {
    try {
      const response = await this.performSave({ rating: rating })
      if (!response.ok) {
        throw new Error('Failed to save rating')
      }
      const responseText = await response.text()
      Turbo.renderStreamMessage(responseText)
    } catch (error) {
      console.error('Error saving rating:', error)
    }
  }

  autoSave() {
    clearTimeout(this.debounceTimer)
    this.debounceTimer = setTimeout(() => {
      this.saveNotes()
    }, 1000) // Wait for 1 second of inactivity before saving
  }

  async saveNotes() {
    const notes = this.notesTarget.value
    try {
      const response = await this.performSave({ notes: notes })
      if (!response.ok) {
        throw new Error('Failed to save notes')
      }
      const responseText = await response.text()
      Turbo.renderStreamMessage(responseText)
    } catch (error) {
      console.error('Error saving notes:', error)
    }
  }

  async performSave(data) {
    return fetch(this.urlValue, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Accept': 'text/vnd.turbo-stream.html, application/json'
      },
      body: JSON.stringify({
        assessment_participation: data
      })
    })
  }
}
