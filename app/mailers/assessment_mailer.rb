class AssessmentMailer < ApplicationMailer
  helper DurationHelper

  def invite_email(assessment_participation)
    @assessment_participation = assessment_participation
    @assessment = @assessment_participation.assessment
    @recipient = @assessment_participation.participant

    mail(
      to: @recipient.email,
      subject: "You've been invited to take an assessment for #{@assessment.business.company}"
    )
  end
end
