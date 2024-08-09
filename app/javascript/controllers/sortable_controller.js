import { Controller } from "@hotwired/stimulus"
import Sortable from 'sortablejs'

// Connects to data-controller="sortable"
export default class extends Controller {
  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 150,
      ghostClass: 'blue-background-class',
      direction: 'horizontal',
      draggable: '.active-test', // Only allow active tests to be dragged
      onEnd: (evt) => {
        this.updateOrder(evt)
      }
    })
  }

  updateOrder(evt) {
    // Get all active test IDs in their new order
    const activeTestIds = Array.from(this.element.querySelectorAll('.active-test input[name="assessment[test_ids][]"]'))
      .map(input => input.value)

    // Get all inactive test placeholders
    const inactiveTests = Array.from(this.element.querySelectorAll('.inactive-test input[name="assessment[test_ids][]"]'))
      .map(() => null)

    // Combine active and inactive tests in the correct order
    const allTests = []
    let activeIndex = 0
    for (let i = 0; i < 5; i++) {
      if (this.element.children[i].classList.contains('active-test')) {
        allTests.push(activeTestIds[activeIndex])
        activeIndex++
      } else {
        allTests.push(null)
      }
    }

    console.log('New order:', allTests)
    // You can send this new order to your server here if needed
  }
}