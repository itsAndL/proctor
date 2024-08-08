class TestLibraryController < ApplicationController
  def index
    # Initialize @tests with all tests by default
    @tests = Test.all

    # Filter by search query if present
    if params[:search_query].present?
      @tests = @tests.filter_by_search_query(params[:search_query])
    end

    # Filter by selected test categories if any
    if params[:test_category].present?
      test_category_ids = params[:test_category].map(&:to_i)
      @tests = @tests.where(test_category_id: test_category_ids)
    end

    # Filter by selected test types if any
    if params[:test_type].present?
      test_types = params[:test_type].map(&:camelize)
      @tests = @tests.where(type: test_types)
    end

    @tests = @tests.order(:title)
  end

  def show
    @test = Test.find(params[:hashid])
  end
end
