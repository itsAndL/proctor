import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-assessment"
export default class extends Controller {
  static values = {
    testId: Number,
    testTitle: String,
    previewQuestionsPath: String
  }

  addTest(event) {
    event.preventDefault()

    const testContainer = document.getElementById('test-container');
    let activeTests = testContainer.querySelectorAll('.active-test');

    // if the maximum number of tests has been reached, do not add a new test
    if (activeTests.length === 5) {
      console.log("Maximum number of tests reached");
      return;
    }

    const testComponent = this.createTestComponent(activeTests.length + 1);

    // If there are active tests, insert after the last one
    if (activeTests.length > 0) {
      const lastActiveTest = activeTests[activeTests.length - 1];
      lastActiveTest.insertAdjacentElement('afterend', testComponent);
    } else {
      // If no active tests, append to the container
      testContainer.prepend(testComponent);
    }

    // Remove the first inactive test
    let inactiveTests = testContainer.querySelectorAll('.inactive-test');
    if (inactiveTests.length > 0) {
      inactiveTests[0].remove();
    }

    // Update active and inactive tests counts
    activeTests = testContainer.querySelectorAll('.active-test');
    inactiveTests = testContainer.querySelectorAll('.inactive-test');

    // Replace the "Add" button with a "Remove" button
    const removeButton = this.createRemoveButton();
    event.target.replaceWith(removeButton);


    // if the maximum number of tests has been reached, disable all add buttons
    if (activeTests.length === 5) {
      this.disableAllAddButtons();
    }
  }

  disableAllAddButtons() {
    const addButtons = document.querySelectorAll('.add-test-btn');
    addButtons.forEach(button => {
      button.disabled = true;
    });
  }

  createTestComponent(number) {
    const testComponent = document.createElement('div');
    testComponent.id = number
    testComponent.className = "active-test group cursor-pointer inline-flex justify-between gap-x-2.5 items-center rounded-xl bg-black pl-5 pr-4 py-2 text-sm font-semibold text-white shadow-sm";

    testComponent.innerHTML = `
      <span class="py-1 truncate">${this.testTitleValue}</span>
      <div class="hidden group-hover:flex gap-x-1.5">
        ${this.previewQuestionsPathValue ? `
          <a href="${this.previewQuestionsPathValue}" target="_blank" class="text-white p-1 hover:rounded-full hover:bg-white hover:text-white hover:bg-opacity-50 hover:shadow-sm">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="size-5">
              <path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 0 1 0-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178Z" />
              <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
            </svg>
          </a>
        ` : ''}
        <button type="button" class="text-white p-1 hover:rounded-full hover:bg-white hover:text-white hover:bg-opacity-50 hover:shadow-sm"
                data-controller="new-assessment"
                data-action="new-assessment#removeTest"
                data-new-assessment-test-id-value="${this.testIdValue}"
                data-new-assessment-test-title-value="${this.testTitleValue}"
                data-new-assessment-preview-questions-path-value="${this.previewQuestionsPathValue}">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="size-5">
            <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
      <input type="hidden" name="assessment[test_ids][]" value="${this.testIdValue}">
    `;

    return testComponent;
  }

  createRemoveButton() {
    const button = document.createElement('button');
    button.type = 'button';
    button.className = 'remove-test-btn danger-button px-3 ml-auto';
    button.innerHTML = `
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-4 -mb-0.5">
        <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
      </svg>
      Remove
    `;
    button.setAttribute('data-action', 'new-assessment#removeTest');
    return button;
  }

  removeTest(event) {
    event.preventDefault()

    const testContainer = document.getElementById('test-container');
    let activeTests = testContainer.querySelectorAll('.active-test');

    // Find the active test to remove
    const testToRemove = event.target.closest('.active-test') || Array.from(activeTests).find(test => {
      const hiddenInput = test.querySelector('input[type="hidden"]');
      return hiddenInput && hiddenInput.value == this.testIdValue;
    });

    if (!testToRemove) {
      console.log("Test not found for removal");
      return;
    }

    // remove the active test and update the active test counts
    testToRemove.remove();
    activeTests = testContainer.querySelectorAll('.active-test');

    // Create a new inactive test element
    const inactiveTest = this.createInactiveTest(activeTests.length + 1);

    // If there are active tests, insert after the last one
    if (activeTests.length > 0) {
      const lastActiveTest = activeTests[activeTests.length - 1];
      lastActiveTest.insertAdjacentElement('afterend', inactiveTest);
    } else {
      // If no active tests, append to the container
      testContainer.prepend(inactiveTest);
    }

    // Replace the "Remove" button with an "Add" button
    const addButton = this.createAddButton();
    const removeButton = event.target.closest('.remove-test-btn') || document.querySelector(`div[data-new-assessment-test-id-value="${this.testIdValue}"]`).querySelector('.remove-test-btn');;
    removeButton.replaceWith(addButton);

    // If we're no longer at the maximum number of tests, enable all add buttons
    if (activeTests.length < 5) {
      this.enableAllAddButtons();
    }
  }

  createInactiveTest(number) {
    const inactiveTest = document.createElement('div');
    inactiveTest.className = "inactive-test cursor-pointer rounded-xl px-5 py-3 text-sm font-semibold text-gray-400 border border-dashed border-gray-400 shadow-sm text-center";
    inactiveTest.textContent = `Test n˚${number}`;
    return inactiveTest;
  }

  createAddButton() {
    const button = document.createElement('button');
    button.type = 'button';
    button.className = 'add-test-btn black-button px-6 ml-auto';
    button.textContent = 'Add';
    button.setAttribute('data-action', 'new-assessment#addTest');
    return button;
  }

  enableAllAddButtons() {
    const addButtons = document.querySelectorAll('.add-test-btn');
    addButtons.forEach(button => {
      button.disabled = false;
    });
  }
}
