class TestsController < ApplicationController
  def index
    # Initialize @tests with all tests by default
    @tests = Test.all

    # Filter by search query if present
    if params[:search_query].present?
      @tests = @tests.filter_by_search_query(params[:search_query])
    end

    # Filter by selected test types if any
    if params[:test_focus].present?
      test_type_ids = params[:test_focus].map(&:to_i)
      @tests = @tests.where(test_type_id: test_type_ids)
    end

    # Filter by selected test formats if any
    if params[:test_format].present?
      test_formats = params[:test_format].map(&:to_i)
      @tests = @tests.where(format: test_formats)
    end
  end

  def show
    @test = Test.find_by_hashid(params[:hashid])
  end
end
