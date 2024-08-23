class AssessmentTestsController < ApplicationController
  include AssessmentItemManagement

  before_action :authenticate_business!

  private

  def association_name
    :assessment_tests
  end

  def item_class
    Test
  end

  def item_param_key
    :test_hashid
  end

  def item_key
    :test
  end

  def item_name
    'test'
  end

  def table_id
    'tests_table'
  end

  def render_table
    TestsTableComponent.new(assessment: @assessment, with_title: string_to_boolean(params[:with_title])).render_in(view_context)
  end

  def render_item_card
    TestCardComponent.new(test: @item, assessment: @assessment).render_in(view_context)
  end
end
