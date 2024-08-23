class TestLibraryController < ApplicationController
  before_action :authenticate_business!

  def index
    query = TestQuery.new

    @tests = query.execute(
      search_query: params[:search_query],
      category_ids: params[:test_category]&.map(&:to_i),
      types: params[:test_type]
    )
  end

  def show
    @test = Test.find(params[:hashid])
  end
end
