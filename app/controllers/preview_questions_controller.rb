class PreviewQuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :hide_navbar

  def show
    @test = Test.find(params[:test_library_hashid])
    @question = Question.find(params[:hashid])
    authorize! @test, with: TestPolicy
    render QuestionAnsweringFormComponent.new(
      business: current_business,
      question: @question,
      test: @test,
      show_progress: false,
      monitoring: false,
      save_path: (test_library_preview_question_path(@test, @question.next_preview(@test)) if @question.next_preview(@test))
    )
  end
end
