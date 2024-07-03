import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fullscreen"
export default class extends Controller {
  static targets = ["nextPage"]

  connect() {
  }

  enterFullscreen() {
    const element = document.documentElement

    if (element.requestFullscreen) {
      element.requestFullscreen()
    } else if (element.mozRequestFullScreen) { // Firefox
      element.mozRequestFullScreen()
    } else if (element.webkitRequestFullscreen) { // Chrome, Safari and Opera
      element.webkitRequestFullscreen()
    } else if (element.msRequestFullscreen) { // IE/Edge
      element.msRequestFullscreen()
    }

    this.nextPageTarget.click();
  }

  exitFullscreen() {
    if (document.exitFullscreen) {
      document.exitFullscreen()
    } else if (document.mozCancelFullScreen) { // Firefox
      document.mozCancelFullScreen()
    } else if (document.webkitExitFullscreen) { // Chrome, Safari and Opera
      document.webkitExitFullscreen()
    } else if (document.msExitFullscreen) { // IE/Edge
      document.msExitFullscreen()
    }

    this.nextPageTarget.click();
  }
}
