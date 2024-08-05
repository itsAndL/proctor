import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-assessment"
export default class extends Controller {
  static values = {
    testId: Number,
    testTitle: String,
    previewQuestionsPath: String
  }

  static MAX_TESTS = 5

  addTest(event) {
    event.preventDefault()

    const testContainer = document.getElementById('test-container')
    const activeTests = testContainer.querySelectorAll('.active-test')

    if (activeTests.length >= this.constructor.MAX_TESTS) {
      console.log("Maximum number of tests reached")
      return
    }

    const testComponent = this.createTestComponent(activeTests.length + 1)
    this.insertTest(testContainer, testComponent, activeTests)
    this.removeInactiveTest(testContainer)
    this.replaceButton(event.target, this.createRemoveButton())
    this.updateButtonStates(testContainer)
    this.updateTestsCount()
  }

  removeTest(event) {
    event.preventDefault()

    const testContainer = document.getElementById('test-container')
    const testToRemove = this.findTestToRemove(event, testContainer)

    if (!testToRemove) {
      console.log("Test not found for removal")
      return
    }

    testToRemove.remove()
    this.addInactiveTest(testContainer)
    this.replaceButton(this.findRemoveButton(event), this.createAddButton())
    this.updateButtonStates(testContainer)
    this.updateTestsCount()
  }

  insertTest(container, test, activeTests) {
    if (activeTests.length > 0) {
      activeTests[activeTests.length - 1].insertAdjacentElement('afterend', test)
    } else {
      container.prepend(test)
    }
  }

  removeInactiveTest(container) {
    const inactiveTests = container.querySelectorAll('.inactive-test')
    if (inactiveTests.length > 0) {
      inactiveTests[0].remove()
    }
  }

  addInactiveTest(container) {
    const activeTests = container.querySelectorAll('.active-test')
    const inactiveTest = this.createInactiveTest(activeTests.length + 1)
    this.insertTest(container, inactiveTest, activeTests)
  }

  updateButtonStates(container) {
    const activeTests = container.querySelectorAll('.active-test')
    const isMaxReached = activeTests.length >= this.constructor.MAX_TESTS
    document.querySelectorAll('.add-test-btn').forEach(btn => btn.disabled = isMaxReached)
  }

  replaceButton(oldButton, newButton) {
    oldButton.replaceWith(newButton)
  }

  findTestToRemove(event, container) {
    return event.target.closest('.active-test') ||
      Array.from(container.querySelectorAll('.active-test')).find(test => {
        const hiddenInput = test.querySelector('input[type="hidden"]')
        return hiddenInput && hiddenInput.value == this.testIdValue
      })
  }

  findRemoveButton(event) {
    return event.target.closest('.remove-test-btn') ||
      document.querySelector(`[data-new-assessment-test-id-value="${this.testIdValue}"] .remove-test-btn`)
  }

  createTestComponent(number) {
    const div = document.createElement('div')
    div.id = number
    div.className = "active-test group cursor-pointer inline-flex justify-between gap-x-2.5 items-center rounded-xl bg-black pl-5 pr-4 py-2 text-sm font-semibold text-white shadow-sm"
    div.innerHTML = this.testComponentTemplate()
    return div
  }

  createInactiveTest(number) {
    const div = document.createElement('div')
    div.className = "inactive-test cursor-pointer rounded-xl px-5 py-3 text-sm font-semibold text-gray-400 border border-dashed border-gray-400 shadow-sm text-center"
    div.innerHTML = `
      <span>Test n˚${number}</span>
      <input type="hidden" name="assessment[test_ids][]" value="">`
    return div
  }

  createRemoveButton() {
    return this.createButton('remove-test-btn danger-button px-3 ml-auto', 'Remove', this.removeIconSvg())
  }

  createAddButton() {
    return this.createButton('add-test-btn black-button px-6 ml-auto', 'Add', '')
  }

  createButton(className, text, iconSvg) {
    const button = document.createElement('button')
    button.type = 'button'
    button.className = className
    button.innerHTML = `${iconSvg}${text}`
    button.setAttribute('data-action', `new-assessment#${text.toLowerCase()}Test`)
    return button
  }

  testComponentTemplate() {
    return `
      <span class="py-1 truncate">${this.testTitleValue}</span>
      <div class="hidden group-hover:flex gap-x-1.5">
        ${this.previewQuestionsPathValue ? this.previewButtonTemplate() : ''}
        ${this.removeButtonTemplate()}
      </div>
      <input type="hidden" name="assessment[test_ids][]" value="${this.testIdValue}">
    `
  }

  previewButtonTemplate() {
    return `
      <a href="${this.previewQuestionsPathValue}" target="_blank" class="text-white p-1 hover:rounded-full hover:bg-white hover:text-white hover:bg-opacity-50 hover:shadow-sm">
        ${this.eyeIconSvg()}
      </a>
    `
  }

  removeButtonTemplate() {
    return `
      <button type="button" class="text-white p-1 hover:rounded-full hover:bg-white hover:text-white hover:bg-opacity-50 hover:shadow-sm"
              data-controller="new-assessment"
              data-action="new-assessment#removeTest"
              data-new-assessment-test-id-value="${this.testIdValue}"
              data-new-assessment-test-title-value="${this.testTitleValue}"
              data-new-assessment-preview-questions-path-value="${this.previewQuestionsPathValue}">
        ${this.closeIconSvg()}
      </button>
    `
  }

  eyeIconSvg() {
    return `
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="size-5">
        <path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 0 1 0-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178Z" />
        <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
      </svg>
    `
  }

  closeIconSvg() {
    return `
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="size-5">
        <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
      </svg>
    `
  }

  removeIconSvg() {
    return `
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-4 -mb-0.5">
        <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
      </svg>
    `
  }

  updateTestsCount() {
    const testsCountElement = document.getElementById('tests-count')
    const activeTestsCount = document.querySelectorAll('.active-test').length
    testsCountElement.textContent = this.pluralize(activeTestsCount, 'test', 'tests')
  }

  pluralize(count, singular, plural) {
    return `${count} ${count === 1 ? singular : plural}`
  }
}