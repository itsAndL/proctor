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
      save_path: if @question.next_preview(@test)
                   test_library_preview_question_path(@test,
                                                      @question.next_preview(@test))
                 end
    )
  end
end
