class InviteCandidatesController < ApplicationController
  include AssessmentFinder
  include TurboStreamRenderer

  before_action :authenticate_business!, except: %i[public_link invite_me]
  before_action :set_assessment, except: :public_link
  before_action :hide_navbar, only: :public_link

  def share; end

  def activate_public_link
    @assessment.activate_public_link!
    render_turbo_stream_update(update_share_link: true, notice: "Assessment public link was successfully activated.")
  end

  def deactivate_public_link
    @assessment.deactivate_public_link!
    render_turbo_stream_update(update_share_link: true, notice: "Assessment public link was successfully deactivated.")
  end

  def public_link
    @assessment = find_assessment_by_public_link
    render :link_inactive unless @assessment.public_link_active?
  end

  def invite_me
    result = InvitationService.invite_participant(@assessment, params[:email])
    handle_invite_me_result(result)
  end

  def invite; end

  def check_candidate
    exists = InvitationService.candidate_exists?(@assessment, params[:email])
    render json: { exists: exists }
  end

  def post_invite
    candidates = JSON.parse(params[:candidates])
    InvitationService.bulk_invite(@assessment, candidates)
    update_candidates_list(update_email_inviting:true, notice: "Invitation was successfully sent.")
  end

  def bulk_invite; end

  def bulk_invite_upload
    if params[:file].present?
      candidates = FileParsingService.parse_bulk_invite_file(params[:file])
      InvitationService.bulk_invite(@assessment, candidates)
      update_candidates_list(update_bulk_inviting: true, notice: "Bulk invitation sent successfully!")
    else
      render_turbo_stream_update(update_bulk_inviting: true, alert: "Please select a file to upload.")
    end
  end

  def bulk_invite_template
    respond_to do |format|
      format.csv { send_data TemplateGenerationService.generate_csv, filename: "bulk_invite_template.csv", type: "text/csv" }
      format.xlsx { send_data TemplateGenerationService.generate_xlsx, filename: "bulk_invite_template.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }
    end
  end

  private

  def handle_invite_me_result(result)
    notice_type = result.success? && result.is_new ? :notice : :alert
    message = if result.success?
                result.is_new ? "Invitation sent successfully!" : "This candidate has already been added to this assessment"
              else
                result.error_message
              end

    redirect_to public_assessment_path(@assessment.public_link_token), notice_type => message
  end


  def update_candidates_list(options = {})
    query = AssessmentParticipationQuery.new(@assessment.assessment_participations)
    assessment_participations = query.execute
    assessment_participations = paginate(query.relation)

    render_turbo_stream_update(
      update_candidates_list: {
        assessment_participations: assessment_participations,
        current_page: @current_page,
        total_items: @total_items,
        per_page: @per_page
      },
      notice: options[:notice] || "Invitation was successfully sent.",
      update_email_inviting: options[:update_email_inviting],
      update_bulk_inviting: options[:update_bulk_inviting]
    )
  end
end
