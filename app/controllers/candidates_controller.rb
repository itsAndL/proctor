class CandidatesController < ApplicationController
  include SecondaryRootPath

  before_action :authenticate_user!, only: %i[new create]
  before_action :authenticate_candidate!, only: %i[edit update]
  before_action :require_new_candidate!, only: %i[new create]

  def new
    @candidate = current_user.build_candidate
  end

  def create
    @candidate = current_user.build_candidate
    @candidate.assign_attributes(candidate_params)

    if @candidate.save
      redirect_to edit_candidate_path(@candidate), notice: 'Your candidate profile was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @candidate = current_candidate
  end

  def update
    @candidate = current_candidate

    if @candidate.update(candidate_params)
      redirect_to secondary_root_path, notice: 'Your candidate profile was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def require_new_candidate!
    return if current_candidate.blank?

    redirect_to edit_candidate_path(current_candidate)
  end

  def candidate_params
    params.require(:candidate).permit(:name, :avatar)
  end
end
