class TestLibraryController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! with: TestPolicy
    query = TestQuery.new
    @tests = query.execute(
      search_query: params[:search_query],
      category_ids: params[:test_category]&.map(&:to_i),
      types: params[:test_type],
      business: current_business,
      only_system: params[:test_source] == 'assesskit' || params[:test_source].blank?,
      only_business: params[:test_source] == 'my_company',
      language: params[:language] || :english
    )
  end

  def show
    @test = Test.find(params[:hashid])
    authorize! @test, with: TestPolicy
  end
end
