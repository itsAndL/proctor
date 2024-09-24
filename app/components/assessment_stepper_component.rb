# frozen_string_literal: true

class AssessmentStepperComponent < ViewComponent::Base
  def initialize(current_step:, assessment: nil)
    @current_step = current_step
    @assessment = assessment
  end

  def steps
    [
      { name: t('.assessment_details'), path: assessment_details_path },
      { name: t('.choose_tests'), path: choose_tests_path },
      { name: t('.add_questions'), path: add_questions_path },
      { name: t('.finalize'), path: finalize_path }
    ]
  end

  private

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

  def step_status(index)
    if index < steps.index { |step| step[:name] == @current_step }
      :completed
    elsif steps[index][:name] == @current_step
      :current
    else
      :upcoming
    end
  end

  def step_linkable?(index)
    @assessment&.persisted? || index == 0
  end
end
