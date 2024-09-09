import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="timer"
export default class extends Controller {
  static targets = [ "container", "progress" ]
  static values = { time: Number }

  connect() {
    this.start()
  }

  start() {
    this.initialTime = this.timeValue
    let startTime = null;

    const animate = (timestamp) => {
      if (!startTime) startTime = timestamp;
      const elapsedTime = timestamp - startTime;
      const remainingTime = Math.max(this.initialTime - Math.floor(elapsedTime / 1000), 0);

      this.containerTarget.textContent = this.formatTime(remainingTime);
      this.progressTarget.style.width = `${(remainingTime / this.initialTime) * 100}%`;

      if (remainingTime <= 0) {
        this.stop();
        // alert("Time's up!"); TODO: Add a modal to show the time's up message
      }

      if ((remainingTime / this.initialTime) * 100 <= 99) {
        this.progressTarget.classList.remove('rounded-full');
        this.progressTarget.classList.add('rounded-l-full');
      }

      if (remainingTime > 0) {
        requestAnimationFrame(animate);
      }
    };

    requestAnimationFrame(animate);
  }

  stop() {
    clearInterval(this.timer)
  }

  formatTime(seconds) {
    const hrs = String(Math.floor(seconds / 3600)).padStart(2, '0')
    const mins = String(Math.floor((seconds % 3600) / 60)).padStart(2, '0')
    const secs = String(seconds % 60).padStart(2, '0')
    return `${hrs}:${mins}:${secs}`
  }
}