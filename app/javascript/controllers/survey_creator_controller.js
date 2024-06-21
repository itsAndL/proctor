import { Controller } from "@hotwired/stimulus"
import * as SurveyCreator from "survey-creator-knockout"

// Connects to data-controller="survey-creator"
export default class extends Controller {
  static targets = ["surveyCreator"]

  connect() {
    this.initializeSurveyCreator();
  }

  initializeSurveyCreator() {
    const creatorOptions = {
      showLogicTab: true,
      isAutoSave: true
    };

    const creator = new SurveyCreator.SurveyCreator(creatorOptions);

    // Render Survey Creator in the specified element
    creator.render(this.surveyCreatorTarget);

    // Call the function to observe and remove the banner
    this.observeAndRemoveBanner();
  }

  observeAndRemoveBanner() {
    // Use MutationObserver to wait until the Survey Creator has been rendered
    const observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        if (mutation.type === "childList") {
          const banner = this.surveyCreatorTarget.querySelector(".svc-creator__banner");
          if (banner) {
            banner.remove();
            observer.disconnect(); // Stop observing after the banner is removed
          }
        }
      });
    });

    observer.observe(this.surveyCreatorTarget, { childList: true, subtree: true });
  }
}
