import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="email-inviting"
export default class extends Controller {
  static targets = ["list", "nameInput", "emailInput", "inviteButton", "addButton", "errorMessage"]
  static values = { candidates: Array, checkCandidatePath: String }

  connect() {
    this.candidatesValue = []
    this.updateInviteButton()
  }

  async addCandidate(event) {
    event.preventDefault()
    const name = this.nameInputTarget.value.trim()
    const email = this.emailInputTarget.value.trim()

    if (this.validateEmail(email)) {
      const exists = await this.checkCandidateEmail(email)
      if (exists) {
        this.showErrorMessage(I18n.email_inviting_controller.candidate_already_invited)
        
      } else {
        this.candidatesValue = [...this.candidatesValue, { name, email }]
        this.renderCandidates()
        this.clearForm()
        this.hideErrorMessage()
      }
    } else {
      this.showErrorMessage(I18n.email_inviting_controller.invalid_email)
    }
  }

  async checkCandidateEmail(email) {
    const response = await fetch(this.checkCandidatePathValue, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        email: email
      })
    })
    const data = await response.json()
    return data.exists
  }

  removeCandidate(event) {
    const index = event.params.index
    this.candidatesValue = this.candidatesValue.filter((_, i) => i !== index)
    this.renderCandidates()
  }

  editCandidate(event) {
    const index = event.params.index
    const candidate = this.candidatesValue[index]
    this.nameInputTarget.value = candidate.name
    this.emailInputTarget.value = candidate.email
    this.removeCandidate(event)
  }

  validateEmail(email) {
    // Basic email validation
    return /\S+@\S+\.\S+/.test(email)
  }

  renderCandidates() {
    this.listTarget.innerHTML = this.candidatesValue.map((candidate, index) => `
      <tr>
        <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-800 sm:pl-6">${candidate.name}</td>
        <td class="whitespace-nowrap px-3 py-4 text-sm font-medium text-gray-800">${candidate.email}</td>
        <td class="whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm sm:pr-6">
          <button type="button" data-action="click->email-inviting#editCandidate" data-email-inviting-index-param="${index}" class="text-gray-700 hover:text-gray-500 mr-1.5">
            <svg class="size-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" data-slot="icon">
              <path d="m5.433 13.917 1.262-3.155A4 4 0 0 1 7.58 9.42l6.92-6.918a2.121 2.121 0 0 1 3 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 0 1-.65-.65Z" />
              <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0 0 10 3H4.75A2.75 2.75 0 0 0 2 5.75v9.5A2.75 2.75 0 0 0 4.75 18h9.5A2.75 2.75 0 0 0 17 15.25V10a.75.75 0 0 0-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5Z" />
            </svg>
          </button>
          <button type="button" data-action="click->email-inviting#removeCandidate" data-email-inviting-index-param="${index}" class="text-gray-700 hover:text-gray-500">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-5">
              <path fill-rule="evenodd" d="M16.5 4.478v.227a48.816 48.816 0 0 1 3.878.512.75.75 0 1 1-.256 1.478l-.209-.035-1.005 13.07a3 3 0 0 1-2.991 2.77H8.084a3 3 0 0 1-2.991-2.77L4.087 6.66l-.209.035a.75.75 0 0 1-.256-1.478A48.567 48.567 0 0 1 7.5 4.705v-.227c0-1.564 1.213-2.9 2.816-2.951a52.662 52.662 0 0 1 3.369 0c1.603.051 2.815 1.387 2.815 2.951Zm-6.136-1.452a51.196 51.196 0 0 1 3.273 0C14.39 3.05 15 3.684 15 4.478v.113a49.488 49.488 0 0 0-6 0v-.113c0-.794.609-1.428 1.364-1.452Zm-.355 5.945a.75.75 0 1 0-1.5.058l.347 9a.75.75 0 1 0 1.499-.058l-.346-9Zm5.48.058a.75.75 0 1 0-1.498-.058l-.347 9a.75.75 0 0 0 1.5.058l.345-9Z" clip-rule="evenodd" />
            </svg>
          </button>
        </td>
      </tr>
    `).join('')
    this.updateInviteButton()
  }

  clearForm() {
    this.nameInputTarget.value = ''
    this.emailInputTarget.value = ''
  }

  updateInviteButton() {
    this.inviteButtonTarget.disabled = this.candidatesValue.length === 0
  }

  showErrorMessage(message) {
    const errorParagraph = this.errorMessageTarget.querySelector('p')
    errorParagraph.textContent = message
    this.errorMessageTarget.classList.remove('hidden')
  }

  hideErrorMessage() {
    this.errorMessageTarget.querySelector('p').textContent = ''
    this.errorMessageTarget.classList.add('hidden')
  }

  inviteCandidates(event) {
    event.preventDefault()
    if (this.candidatesValue.length === 0) return

    const formData = new FormData()
    formData.append('candidates', JSON.stringify(this.candidatesValue))

    fetch(this.element.action, {
      method: 'POST',
      body: formData,
      headers: {
        'Accept': 'text/vnd.turbo-stream.html',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    }).then(response => response.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
  }
}