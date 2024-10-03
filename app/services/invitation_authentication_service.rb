class InvitationAuthenticationService
  def initialize(controller)
    @controller = controller
    @params = controller.params
  end

  def authenticate
    return unless invitation_page?

    assessment_participation = AssessmentParticipation.find_by(invitation_token: @params[:token])
    return unless assessment_participation

    if assessment_participation.temp_candidate_id.nil?
      @controller.redirect_to(
        @controller.new_candidate_session_path(email_address: assessment_participation.candidate.email),
        alert: I18n.t('alert.candidate_required')
      )
    else
      @controller.redirect_to(
        @controller.new_candidate_registration_path(email_address: assessment_participation.temp_candidate.email),
        alert: I18n.t('alert.candidate_registration_required')
      )
    end
  end

  private

  def invitation_page?
    @controller.class.module_parent.to_s == 'Candidate' &&
      @controller.controller_name == 'assessment_participations' &&
      @controller.action_name == 'invitation'
  end
end
