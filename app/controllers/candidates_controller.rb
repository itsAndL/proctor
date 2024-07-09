class CandidatesController < ApplicationController
  before_action :require_new_candidate!, only: %i[new create]

  def new
    @candidate = current_user.build_candidate
  end

  def create
    @candidate = current_user.build_candidate
    @candidate.assign_attributes(candidate_params)

    if @candidate.save
      redirect_to edit_candidate_path(@candidate.hashid), notice: 'Your candidate profile was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @candidate = current_user.candidate
  end

  def update
    @candidate = current_user.candidate

    if @candidate.update(candidate_params)
      redirect_to candidate_assessments_path, notice: 'Your candidate profile was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def require_new_candidate!
    return if current_user.candidate.blank?

    redirect_to edit_candidate_path(current_user.candidate)
  end

  def candidate_params
    params.require(:candidate).permit(:name, :avatar)
  end
end
