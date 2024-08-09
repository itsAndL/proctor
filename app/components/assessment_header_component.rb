# frozen_string_literal: true

class AssessmentHeaderComponent < ViewComponent::Base
  def initialize(assessment:, current_action:)
    @assessment = assessment
    @current_action = current_action
  end

  private

  def title
    @current_action == 'new' ? 'Untitled assessment' : @assessment.title
  end

  def tests_count
    count = @assessment.tests.count
    "#{count} #{count == 1 ? 'test' : 'tests'}"
  end

  def back_link
    "/customer/assessments"
  end

  def save_and_exit_button
    if @current_action == 'new'
      link_to "Exit", back_link, class: "secondary-button px-6"
    else
      button_tag "Save and exit",
                 type: "button",
                 class: "secondary-button px-3",
                 data: {
                   controller: "form-submit",
                   form_submit_save_and_exit_value: "true",
                   action: "form-submit#submitForm"
                 }
    end
  end
end
