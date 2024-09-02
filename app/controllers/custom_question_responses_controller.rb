class CustomQuestionResponsesController < ApplicationController
  before_action :set_custom_question_response

  def edit; end

  def update
    if @custom_question_response.update(custom_question_response_params)
      render(turbo_stream:
      [
        turbo_stream.replace('report-custom-questions',
          ReportCustomQuestionsComponent.new(assessment_participation: @custom_question_response.assessment_participation)
        ),
        turbo_stream.replace('modal', helpers.turbo_frame_tag('modal')),
        turbo_stream.replace('notification', NotificationComponent.new(notice: 'Rating was successfully updated.'))
      ]
    )
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def download
    if @custom_question_response.file_upload.attached?
      send_data @custom_question_response.file_upload.download,
                filename: @custom_question_response.file_upload.filename.to_s,
                content_type: @custom_question_response.file_upload.content_type
    else
      redirect_to edit_custom_question_response_path(@custom_question_response), alert: 'No file attached to this response.'
    end
  end

  private

  def set_custom_question_response
    @custom_question_response = CustomQuestionResponse.find(params[:hashid])
  end

  def custom_question_response_params
    params.require(:custom_question_response).permit(:rating, :comment)
  end
end
