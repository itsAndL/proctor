class TestsController < ApplicationController
  def index
    @tests = Test.all
  end

  def show
    @test = Test.find_by_hashid(params[:hashid])
  end
end
