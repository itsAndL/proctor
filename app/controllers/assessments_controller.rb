class AssessmentsController < ApplicationController
  before_action :set_assessment, only: %i[edit update choose_tests update_tests add_questions update_questions]

  def new
    @assessment = Assessment.new
  end

  def create
    @assessment = Assessment.new(assessment_params)
    @assessment.business = current_user.business

    if @assessment.save
      redirect_to choose_tests_assessment_path(@assessment.hashid), notice: 'Your assessment was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @assessment.update(assessment_params)
      redirect_to choose_tests_assessment_path(@assessment.hashid), notice: 'Your assessment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def choose_tests
  end

  def update_tests
    if @assessment.update(test_params)
      redirect_to add_questions_assessment_path(@assessment.hashid)
    else
      render :choose_tests
    end
  end

  def add_questions
  end

  def update_questions
    if @assessment.update(question_params)
      redirect_to finalize_assessment_path(@assessment.hashid)
    else
      render :add_questions
    end
  end

  private

  def set_assessment
    @assessment = Assessment.find(params[:hashid])
  end

  def assessment_params
    params.require(:assessment).permit(:title, :language)
  end

  def test_params
    params.require(:assessment).permit(test_ids: [])
  end

  def question_params
    params.require(:assessment).permit(question_ids: [])
  end
end
