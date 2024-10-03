class AssessmentParticipationsController < ApplicationController
  before_action :authenticate_business!
  before_action :set_assessment_participation

  def delete_confirmation; end

  def destroy
    @assessment = @assessment_participation.assessment
    @assessment_participation.destroy

    query = AssessmentParticipationQuery.new(@assessment.assessment_participations)
    query.execute
    assessment_participations = paginate(query.relation)

    render(turbo_stream:
      [
        turbo_stream.replace('candidates-list',
                             CandidatesListComponent.new(
                               assessment: @assessment,
                               assessment_participations:,
                               current_page: @current_page,
                               total_items: @total_items,
                               per_page: @per_page
                             )),
        turbo_stream.replace('modal', helpers.turbo_frame_tag('modal')),
        turbo_stream.replace('notification', NotificationComponent.new(notice: t('flash.candidate_deleted')))
      ])
  end

  def send_reminder
    result = InvitationService.send_reminder(@assessment_participation)

    if result.success?
      render turbo_stream: turbo_stream.replace('notification', NotificationComponent.new(notice: t('flash.reminder_sent')))
    else
      render turbo_stream: turbo_stream.replace('notification', NotificationComponent.new(alert: result.error_message))
    end
  end

  def report; end

  def rate
    if @assessment_participation.update(assessment_participation_params)
      render turbo_stream: [
        turbo_stream.replace('notification',
                             NotificationComponent.new(notice: t('flash.rating_updated'))),
        turbo_stream.replace(star_rating_identifier, StarRatingComponent.new(@assessment_participation))
      ]
    else
      render turbo_stream: turbo_stream.replace('notification',
                                                NotificationComponent.new(alert: @assessment_participation.errors.full_messages.join(', '))), status: :unprocessable_entity
    end
  end

  private

  def set_assessment_participation
    @assessment_participation = AssessmentParticipation.find(params[:hashid])
  end

  def assessment_participation_params
    params.require(:assessment_participation).permit(:rating, :notes)
  end

  def star_rating_identifier
    "star-rating-assessment_participation-#{@assessment_participation.hashid}"
  end
end
