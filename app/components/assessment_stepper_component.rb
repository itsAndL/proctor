# frozen_string_literal: true

class AssessmentStepperComponent < ViewComponent::Base
  ASSESSMENT_STEPS = {
    assessment_details: 0,
    choose_tests: 1,
    add_questions: 2,
    finalize: 3
  }.freeze

  def initialize(current_step:, assessment: nil)
    @current_step = current_step
    @assessment = assessment
  end

  def steps
    ASSESSMENT_STEPS.keys.map do |step_name|
      {
        name: t(".#{step_name}"),
        path: step_path(step_name),
        status: step_status(ASSESSMENT_STEPS[step_name]),
        linkable: step_linkable?(step_name)
      }
    end
  end

  private

  def step_path(step_name)
    case step_name
    when :assessment_details
      assessment_details_path
    when :choose_tests
      choose_tests_path
    when :add_questions
      add_questions_path
    when :finalize
      finalize_path
    end
  end

  def assessment_details_path
    @assessment&.persisted? ? edit_assessment_path(@assessment) : new_assessment_path
  end

  def choose_tests_path
    @assessment&.persisted? ? choose_tests_assessment_path(@assessment) : '#'
  end

  def add_questions_path
    @assessment&.persisted? ? add_questions_assessment_path(@assessment) : '#'
  end

  def finalize_path
    @assessment&.persisted? ? finalize_assessment_path(@assessment) : '#'
  end

  def step_status(step_index)
    current_index = ASSESSMENT_STEPS[@current_step]

    if step_index < current_index
      :completed
    elsif step_index == current_index
      :current
    else
      :upcoming
    end
  end

  def step_linkable?(step_name)
    @assessment&.persisted? || step_name == :assessment_details
  end
end
