import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="question_answer"
export default class extends Controller {

  static targets = [ "form","formSubmit", "trigger", "modal", "timerLabel", "timerProgress" ]
  static values = { duration: Number }

  connect() {
    if (this.hasModalTarget) {
      this.triggerTarget.addEventListener("click", this.sendForm.bind(this))
    } else {
      this.triggerTarget.addEventListener("click", () => this.formSubmitTarget.click())
    }
    console.log('Connected!', this.durationValue, this.timerLabelTarget, this.timerProgressTarget);
    this.start()
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
    this.formSubmitTarget.click()
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
  
    // Check overall validity
    const isValid = isRadioValid || isCheckboxValid;
    
    console.log('Selected Radio:', selectedRadio ? selectedRadio.value : 'None');
    console.log('Selected Checkboxes:', selectedCheckboxes.map(option => option.value));
  
    return isValid;
  }

  start() {
    this.initialTime = this.durationValue
    let startTime = null;

    const animate = (timestamp) => {
      if (!startTime) startTime = timestamp;
      const elapsedTime = timestamp - startTime;
      const remainingTime = Math.max(this.initialTime - Math.floor(elapsedTime / 1000), 0);

      this.timerLabelTarget.textContent = this.formatTime(remainingTime);
      this.timerProgressTarget.style.width = `${(remainingTime / this.initialTime) * 100}%`;

      if (remainingTime <= 0) {
        this.stop();
        // show alert when clicking okay it will submit the form
        this.formSubmitTarget.click()
      }

      if ((remainingTime / this.initialTime) * 100 == 100) {
        this.timerProgressTarget.classList.add('rounded-full');
      }

      if ((remainingTime / this.initialTime) * 100 <= 99) {
        this.timerProgressTarget.classList.remove('rounded-full');
        this.timerProgressTarget.classList.add('rounded-l-full');
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