# frozen_string_literal: true

class CustomQuestionsTableComponent < ViewComponent::Base
  def initialize(assessment:, with_title: false)
    @assessment = assessment
    @with_title = with_title
    @custom_questions = assessment.custom_questions.includes(:assessment_custom_questions)
  end

  private

  def render_position_button(custom_question, direction, index)
    assessment_custom_question = custom_question.assessment_custom_questions.find_by(assessment: @assessment)

    if can_move?(direction, index)
      button_to(
        helpers.change_position_assessment_custom_question_assessment_custom_question_path(
          @assessment, custom_question, assessment_custom_question
        ),
        method: :patch,
        class: 'rounded-full p-2 text-slate-900 hover:bg-zinc-200',
        params: { direction:, with_title: @with_title }
      ) do
        helpers.svg_tag(direction_icon(direction), class: "size-4", "stroke-width": 3)
      end
    else
      content_tag(:div, class: 'p-2 text-gray-300') do
        helpers.svg_tag(direction_icon(direction), class: "size-4", "stroke-width": 3)
      end
    end
  end

  def can_move?(direction, index)
    case direction
    when :up then index > 0
    when :down then index < @custom_questions.size - 1
    end
  end

  def direction_icon(direction)
    direction == :up ? "chevron_up" : "chevron_down"
  end
end
