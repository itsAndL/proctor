class AssessmentsController < ApplicationController
  def new
    @assessment = Assessment.new
  end

  def create
    @assessment = Assessment.new(assessment_params)
    @assessment.business = current_user.business

    if @assessment.save
      redirect_to edit_assessment_path(@assessment.hashid), notice: 'Your assessment was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def assessment_params
    params.require(:assessment).permit(:title, :language)
  end
end
