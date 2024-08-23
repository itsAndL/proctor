class PreviewQuestionsController < ApplicationController
  before_action :authenticate_business!
  before_action :hide_navbar

  def show
    @test = Test.find(params[:test_library_hashid])
    @question = Question.find(params[:hashid])
  end
end
