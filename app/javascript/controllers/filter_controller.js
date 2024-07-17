import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {
  static targets = ["section", "chevronUp", "chevronDown"]

  toggle() {
    const largeScreen = window.matchMedia('(min-width: 1024px)').matches;
    const hiddenClass = largeScreen ? "lg:hidden" : "hidden";
    const blockClass = largeScreen ? "lg:block" : "block";

    this.sectionTarget.classList.toggle(hiddenClass);
    this.sectionTarget.classList.toggle(blockClass);
    this.chevronUpTarget.classList.toggle(hiddenClass);
    this.chevronUpTarget.classList.toggle(blockClass);
    this.chevronDownTarget.classList.toggle(hiddenClass);
    this.chevronDownTarget.classList.toggle(blockClass);
  }
}