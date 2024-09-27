class PreviewQuestionsController < ApplicationController
  before_action :authenticate_business!
  before_action :hide_navbar

  def show
    @test = Test.find(params[:test_library_hashid])
    @question = @test.questions.find(params[:question_hashid])
    @test_question = @test.test_questions.find_by(question: @question)

    render QuestionAnsweringFormComponent.new(
      business: current_business,
      question: @question,
      test: @test,
      show_progress: false,
      monitoring: false,
      save_path: if @test.next_preview(@test_question).nil?
                   test_library_preview_question_path(@test,
                                                      @test.next_preview(@test_question))
                 end
    )
  end
end
