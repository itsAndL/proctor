class PublicAssessmentsController < ApplicationController
  before_action :set_assessment

  def show
    unless @assessment.public_link_active?
      render :link_inactive and return
    end
  end

  def start
    unless @assessment.public_link_active?
      render :link_inactive and return
    end

    if user_signed_in?
      handle_signed_in_user
    else
      store_location_for(:user, request.fullpath)
      redirect_to new_user_session_path, alert: "Please sign in or sign up to start the assessment."
    end
  end

  private

  def set_assessment
    @assessment = Assessment.find_by!(public_link_token: params[:public_link_token])
  end

  def handle_signed_in_user
    if current_candidate
      create_participation
    else
      redirect_to new_candidate_path, notice: "Please complete your candidate profile to start the assessment."
    end
  end

  def create_participation
    participation = AssessmentParticipation.create!(
      assessment: @assessment,
      candidate: current_candidate,
      status: :invitation_clicked
    )
    redirect_to "/candidate/assessments/1?status=invited", notice: "Assessment started successfully."
  end
end
