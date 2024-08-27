class InviteCandidatesController < ApplicationController
  before_action :authenticate_business!, except: %i[public_link invite_me]
  before_action :set_assessment, except: :public_link
  before_action :hide_navbar, only: :public_link

  def share; end

  def activate_public_link
    @assessment.activate_public_link!
    render_turbo_stream(
      update_share_link: true,
      notice: "Assessment public link was successfully activated."
    )
  end

  def deactivate_public_link
    @assessment.deactivate_public_link!
    render_turbo_stream(
      update_share_link: true,
      notice: "Assessment public link was successfully deactivated."
    )
  end

  def public_link
    @assessment = Assessment.find_by!(public_link_token: params[:public_link_token])
    render :link_inactive unless @assessment.public_link_active?
  end

  def invite_me
    participation, is_new = InvitationService.invite_participant(@assessment, params[:email])

    if is_new
      redirect_to public_assessment_path(@assessment.public_link_token), notice: "Invitation sent successfully!"
    else
      redirect_to public_assessment_path(@assessment.public_link_token), alert: "This candidate has already been added to this assessment"
    end
  end

  def invite; end

  def check_candidate
    email = params[:email]

    exists = AssessmentParticipation.exists?(
      assessment: @assessment,
      candidate: Candidate.with_email(email)
    ) || AssessmentParticipation.exists?(
      assessment: @assessment,
      temp_candidate: TempCandidate.where(email: email)
    )

    render json: { exists: exists }
  end

  def post_invite
    candidates = JSON.parse(params[:candidates])

    candidates.each do |candidate_data|
      InvitationService.invite_participant(@assessment, candidate_data['email'], candidate_data['name'])
    end

    query = AssessmentParticipationQuery.new(@assessment.assessment_participations)
    assessment_participations = query.execute
    assessment_participations = paginate(query.relation)

    render_turbo_stream(
      update_email_inviting: true,
      update_candidates_list: {
        assessment_participations: assessment_participations,
        current_page: @current_page,
        total_items: @total_items,
        per_page: @per_page
      },
      notice: "Invitation was successfully sent."
    )
  end

  def bulk_invite; end

  private

  def set_assessment
    @assessment = Assessment.find(params[:hashid])
  end

  def render_turbo_stream(options = {})
    streams = []

    streams << turbo_stream.replace('share-link', ShareLinkComponent.new(assessment: @assessment)) if options[:update_share_link]

    if options[:update_email_inviting]
      streams << turbo_stream.replace('email-inviting', EmailInvitingComponent.new(assessment: @assessment))
    end

    if options[:update_candidates_list]
      streams << turbo_stream.replace('candidates-list',
        CandidatesListComponent.new(
          assessment: @assessment,
          **options[:update_candidates_list]
        )
      )
    end

    streams << turbo_stream.replace('notification', NotificationComponent.new(notice: options[:notice])) if options[:notice]

    render turbo_stream: streams
  end
end
