import { Controller } from "@hotwired/stimulus"
import * as Survey from "survey-knockout-ui"
import ko from "knockout"
import plainLight from "survey-core/themes/plain-light";

// Connects to data-controller="survey"
export default class extends Controller {
  static targets = ["surveyElement"]

  connect() {
    this.initializeSurvey()
  }

  initializeSurvey() {
    // Define your survey JSON
    const surveyJson = {
      title: "Business Manager Assessment",
      pages: [
        {
          name: "page1",
          elements: [
            {
              type: "radiogroup",
              name: "question1",
              title: "How would you approach setting strategic goals for your team?",
              choices: [
                { value: "Item 1", text: "By following a top-down approach where goals are dictated by senior management." },
                { value: "Item 2", text: "By collaborating with team members to ensure their input and buy-in." },
                { value: "Item 3", text: "By setting ambitious goals independently to challenge the team." },
                { value: "Item 4", text: "By reviewing past performance and setting incremental improvements." }
              ]
            },
            {
              type: "radiogroup",
              name: "question2",
              title: "What is your preferred method for managing a project with tight deadlines?",
              choices: [
                { value: "Item 1", text: "Micro-managing every aspect to ensure no detail is overlooked." },
                { value: "Item 2", text: "Delegating tasks to trusted team members and monitoring progress closely." },
                { value: "Item 3", text: "Creating a detailed project plan and sticking rigidly to it." },
                { value: "Item 4", text: "Allowing flexibility and encouraging creative solutions from the team." }
              ]
            }
          ]
        }
      ]
    }

    // Create the Survey model
    const survey = new Survey.Model(surveyJson)
    survey.applyTheme(plainLight);

    survey.onComplete.add((sender, options) => {
      console.log(JSON.stringify(sender.data, null, 3));
    });

    ko.applyBindings({ model: survey }, this.surveyElementTarget);
  }
}
