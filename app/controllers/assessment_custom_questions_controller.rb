class AssessmentCustomQuestionsController < ApplicationController
  before_action :set_assessment
  before_action :set_custom_question
  before_action :set_assessment_custom_question, only: %i[change_position destroy]

  def create
    @assessment.assessment_custom_questions.create(custom_question: @custom_question)
    respond_with_turbo_stream
  end

  def change_position
    case params[:direction]
    when 'up'
      @assessment_custom_question.move_higher
    when 'down'
      @assessment_custom_question.move_lower
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          'custom_questions_table',
          CustomQuestionsTableComponent.new(assessment: @assessment).render_in(view_context)
        )
      end
    end
  end

  def destroy
    @assessment_custom_question.destroy
    respond_with_turbo_stream
  end

  private

  def set_assessment
    @assessment = Assessment.find(params[:assessment_hashid])
  end

  def set_custom_question
    @custom_question = CustomQuestion.find(params[:custom_question_hashid])
  end

  def set_assessment_custom_question
    @assessment_custom_question = @assessment.assessment_custom_questions.find_by!(custom_question: @custom_question)
  end

  def assessment_custom_question_params
    params.require(:assessment_custom_question).permit(:position)
  end

  def respond_with_turbo_stream
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream_updates
      end
    end
  end

  def turbo_stream_updates
    [
      turbo_stream.replace(
        'custom_questions_table',
        CustomQuestionsTableComponent.new(assessment: @assessment).render_in(view_context)
      ),
      turbo_stream.replace(
        "custom_question_#{@custom_question.hashid}",
        CustomQuestionCardComponent.new(custom_question: @custom_question, assessment: @assessment).render_in(view_context)
      )
    ]
  end
end
