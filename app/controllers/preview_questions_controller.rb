class PreviewQuestionsController < ApplicationController
  def show
    @test = Test.find_by_hashid(params[:test_hashid])
    @question = Question.find_by_hashid(params[:hashid])
  end
end
