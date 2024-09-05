import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "slider", "progress", "handle", "sliderContainer"]
  static values = { screenshots: Array }

  connect() {
    if (this.hasScreenshotsValue) {
      this.imageCache = new Map()
      this.preloadThumbnails()
      this.updateScreenshot()
    }
    this.isDragging = false
    this.boundDrag = this.drag.bind(this)
    this.boundStopDragging = this.stopDragging.bind(this)
  }

  startDragging(event) {
    event.preventDefault()
    this.isDragging = true
    document.addEventListener('mousemove', this.boundDrag)
    document.addEventListener('mouseup', this.boundStopDragging)
    document.addEventListener('touchmove', this.boundDrag)
    document.addEventListener('touchend', this.boundStopDragging)
  }

  stopDragging() {
    this.isDragging = false
    document.removeEventListener('mousemove', this.boundDrag)
    document.removeEventListener('mouseup', this.boundStopDragging)
    document.removeEventListener('touchmove', this.boundDrag)
    document.removeEventListener('touchend', this.boundStopDragging)
  }

  drag(event) {
    if (!this.isDragging) return
    this.moveSliderTo(event.clientX || event.touches[0].clientX)
  }

  handleBarClick(event) {
    this.moveSliderTo(event.clientX)
  }

  moveSliderTo(clientX) {
    const sliderRect = this.sliderContainerTarget.getBoundingClientRect()
    const x = clientX - sliderRect.left
    const percentage = Math.max(0, Math.min(1, x / sliderRect.width))

    this.sliderTarget.value = percentage * (this.screenshotsValue.length - 1)
    this.updateScreenshot()
  }

  preloadThumbnails() {
    this.screenshotsValue.forEach(screenshot => {
      const img = new Image()
      img.src = screenshot.thumb_url
    })
  }

  async updateScreenshot() {
    const value = this.sliderTarget.value
    const index = Math.round(parseFloat(value))
    const screenshot = this.screenshotsValue[index]

    // Immediately show thumbnail
    this.imageTarget.src = screenshot.thumb_url

    // Load preview if not in cache
    if (!this.imageCache.has(index)) {
      const img = new Image()
      img.src = screenshot.preview_url
      await img.decode()
      this.imageCache.set(index, img)
    }

    // Show preview
    this.imageTarget.src = screenshot.preview_url

    // Update progress and handle
    const progressPercentage = (value / (this.screenshotsValue.length - 1)) * 100
    this.progressTarget.style.width = `${progressPercentage}%`
    this.handleTarget.style.left = `calc(${progressPercentage}% - 8px)`
  }
}