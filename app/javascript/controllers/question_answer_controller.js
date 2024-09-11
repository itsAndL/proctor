import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="question_answer"
export default class extends Controller {
  static targets = [ "form","formSubmit", "trigger", "modal" ]

  connect() {
    if (this.hasModalTarget) {
      this.triggerTarget.addEventListener("click", this.sendForm.bind(this))
    } else {
      this.triggerTarget.addEventListener("click", () => this.formSubmitTarget.click())
    }
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
    
}
