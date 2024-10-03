class AssessmentMailer < ApplicationMailer
  helper DurationHelper

  def invite_email(assessment_participation)
    setup_email_variables(assessment_participation)
    mail(
      to: @email,
      subject: t('.invite_subject', company: @assessment.business.company)
    )
  end

  def reminder_email(assessment_participation)
    setup_email_variables(assessment_participation)
    mail(
      to: @email,
      subject: t('.reminder_subject', company: @assessment.business.company)
    )
  end

  private

  def setup_email_variables(assessment_participation)
    @assessment_participation = assessment_participation
    @assessment = @assessment_participation.assessment
    @recipient = @assessment_participation.participant
    @email = @recipient.email
    I18n.locale = if @assessment_participation.candidate.present?
                    @recipient.user.locale
                  else
                    :en
                  end
  end
end
