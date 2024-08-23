class AssessmentCustomQuestionsController < ApplicationController
  include AssessmentItemManagement

  before_action :authenticate_business!

  private

  def association_name
    :assessment_custom_questions
  end

  def item_class
    CustomQuestion
  end

  def item_param_key
    :custom_question_hashid
  end

  def item_key
    :custom_question
  end

  def item_name
    'custom_question'
  end

  def table_id
    'custom_questions_table'
  end

  def render_table
    CustomQuestionsTableComponent.new(assessment: @assessment, with_title: string_to_boolean(params[:with_title])).render_in(view_context)
  end

  def render_item_card
    CustomQuestionCardComponent.new(custom_question: @item, assessment: @assessment).render_in(view_context)
  end
end
