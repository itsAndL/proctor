class AssessmentMailer < ApplicationMailer
  helper DurationHelper

  def invite_email(assessment_participation)
    setup_email_variables(assessment_participation)
    @account_exists = User.exists?(email: @email)
    mail(
      to: @email,
      subject: "You've been invited to take an assessment for #{@assessment.business.company}"
    )
  end

  def reminder_email(assessment_participation)
    setup_email_variables(assessment_participation)
    mail(
      to: @email,
      subject: "Reminder: Complete your assessment for #{@assessment.business.company}"
    )
  end

  private

  def setup_email_variables(assessment_participation)
    @assessment_participation = assessment_participation
    @assessment = @assessment_participation.assessment
    @recipient = @assessment_participation.participant
    @email = @recipient.email
  end
end
