# frozen_string_literal: true

class TestsTableComponent < ViewComponent::Base
  def initialize(assessment:, with_title: false, with_actions: true)
    @assessment = assessment
    @with_title = with_title
    @with_actions = with_actions
    @tests = assessment.tests.includes(:assessment_tests)
  end

  private

  def render_position_button(test, direction, index)
    assessment_test = test.assessment_tests.find_by(assessment: @assessment)

    if can_move?(direction, index)
      button_to(
        helpers.change_position_assessment_test_assessment_test_path(
          @assessment, test, assessment_test
        ),
        method: :patch,
        class: 'rounded-full p-2 text-slate-900 hover:bg-zinc-200',
        params: { direction:, with_title: @with_title }
      ) do
        helpers.svg_tag(direction_icon(direction), class: 'size-4', 'stroke-width': 3)
      end
    else
      content_tag(:div, class: 'p-2 text-gray-300') do
        helpers.svg_tag(direction_icon(direction), class: 'size-4', 'stroke-width': 3)
      end
    end
  end

  def can_move?(direction, index)
    case direction
    when :up then index.positive?
    when :down then index < @tests.size - 1
    end
  end

  def direction_icon(direction)
    direction == :up ? 'chevron_up' : 'chevron_down'
  end
end
