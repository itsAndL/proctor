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
      show_progress: false,
      monitoring: false,
      save_path: if @test.next_preview
                   test_library_preview_question_path(@test,
                                                      @test.next_preview)
                 end
    )
  end
end
