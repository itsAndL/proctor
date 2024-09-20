import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="question_answer"
export default class extends Controller {

  static targets = ["form", "formSubmit", "trigger", "modal", "timerLabel", "timerProgress"]
  static values = { durationLeft: Number, duration: Number }


  connect() {
    if (this.hasModalTarget) {
      this.triggerTarget.addEventListener("click", this.sendForm.bind(this))
    } else {
      this.triggerTarget.addEventListener("click", () => this.formSubmitTarget.click())
    } this.start()
  }

  sendForm() {
    if (this.isFormValid()) {
      this.formSubmitTarget.click()
    } else {
      this.showAlertModal()
    }
  }

  showAlertModal() {
    this.modalTarget.showModal()
  }

  skip() {
    const skipInput = document.createElement('input');
    skipInput.type = 'hidden';
    skipInput.name = 'skip';
    skipInput.value = 'true';
    this.formTarget.appendChild(skipInput);
    this.formSubmitTarget.click();
  }

  close() {
    this.modalTarget.close()
  }

  isFormValid() {
    // Handle radio buttons
    const selectedRadio = this.formTarget.querySelector('input[name="selected_option"]:checked');
    const isRadioValid = selectedRadio !== null;

    // Handle checkboxes
    const selectedCheckboxes = Array.from(this.formTarget.querySelectorAll('input[name="selected_options[]"]:checked'));
    const isCheckboxValid = selectedCheckboxes.length > 0;

    // Handle text inputs with name "essay_content"
    const textInput = this.formTarget.querySelector('input[name="essay_content"]');
    const isTextValid = textInput ? textInput.value.length > 0 : false;

    // Handle file upload input with name "file_upload"
    const fileInput = this.formTarget.querySelector('input[name="file_upload"]');
    const isFileValid = fileInput ? fileInput.files.length > 0 : false;
    const isValid = isRadioValid || isCheckboxValid || isTextValid || isFileValid;

    return isValid;
  }

  start() {
    this.initialTime = this.durationValue;
    let remainingTime = this.durationLeftValue * 1000;

    if (remainingTime <= 0) {
      remainingTime = 0;
    }

    const startTime = performance.now();
    const endTime = startTime + remainingTime;
    const animate = (timestamp) => {
      let timeLeft = Math.max(endTime - timestamp, 0);
      if (isNaN(timeLeft)) {
        timeLeft = 0;
      }
      this.timerLabelTarget.textContent = this.formatTime(Math.floor(timeLeft / 1000));
      this.timerProgressTarget.style.width = `${(timeLeft / (this.initialTime * 1000)) * 100}%`;

      if (timeLeft <= 0) {
        this.stop();
        this.formSubmitTarget.click(); 
        return;
      }

      if ((timeLeft / (this.initialTime * 1000)) * 100 === 100) {
        this.timerProgressTarget.classList.add('rounded-full');
      } else {
        this.timerProgressTarget.classList.remove('rounded-full');
        this.timerProgressTarget.classList.add('rounded-l-full');
      }

      requestAnimationFrame(animate);
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