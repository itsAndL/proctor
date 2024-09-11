class PreviewQuestionsController < ApplicationController
  before_action :authenticate_business!
  before_action :hide_navbar

  def show
    @test = Test.find(params[:test_library_hashid])
    @question = Question.find(params[:hashid])

    render QuestionAnsweringFormComponent.new(
      business: current_business,
      question: @question,
      test: @test,
      is_preview: true,
      show_progress: false
    )
  end
end
