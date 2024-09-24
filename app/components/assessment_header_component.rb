# frozen_string_literal: true

class AssessmentHeaderComponent < ViewComponent::Base
  def initialize(assessment:)
    @assessment = assessment
  end

  private

  def save_and_exit_button
    if @assessment.new_record?
      link_to t('.exit'), assessments_path, class: 'secondary-button px-6'
    else
      button_tag t('.save_and_exit'),
                 type: 'button',
                 class: 'secondary-button px-3',
                 data: {
                   controller: 'form-submit',
                   form_submit_save_and_exit_value: 'true',
                   action: 'form-submit#submitForm'
                 }
    end
  end
end
