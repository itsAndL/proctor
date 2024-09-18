class Api::MonitoringController < ApplicationController
  def update
    assessment_participation = AssessmentParticipation.find(params[:hashid])
    assessment_participation.update_monitoring_data(monitoring_params)
    head :ok
  end

  private

  def monitoring_params
    params.permit(:webcam_enabled, :fullscreen_exited, :mouse_left_window, :device, :location, :ip, :webcam_image)
  end
end
