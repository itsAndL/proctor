class PreviewQuestionsController < ApplicationController
  def show
    @test = Test.find(params[:test_library_hashid])
    @question = Question.find(params[:hashid])
  end
end
