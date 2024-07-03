import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="slider"
export default class extends Controller {
  static values = {
    firstSlide: Number, default: 1,
    slideCount: Number
  }

  connect() {
    this.currentSlide = this.firstSlideValue
  }

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

  active({ params: { clickedSlide } }) {
    console.log("My name is 1")
    console.log("---> I'm the current:", this.currentSlide)
    console.log("---> I'm the next:", clickedSlide)
    if (clickedSlide !== this.currentSlide) {
      console.log("My name is 2")
      this.currentSlide = clickedSlide

      const lastSlide = this.firstSlideValue + this.slideCountValue - 1;

      // show the current slide
      for (let i = this.firstSlideValue; i <= lastSlide; i++) {
        const slide = document.getElementById(`slide-${i}`)
        if (slide) {
          if (i === this.currentSlide) {
            slide.classList.remove('hidden')
            console.log(`---> I Win 🏆: ${i}.`)
          } else {
            slide.classList.add('hidden')
            console.log(`---> I Lost 🤬: ${i}.`)
          }
        }
      }
    }
  }
}
