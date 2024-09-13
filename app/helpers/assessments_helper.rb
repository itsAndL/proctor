module AssessmentsHelper
  def assessment_invite_eligibility_path(assessment)
    (assessment.tests.any? || assessment.custom_questions.any?) ? share_assessment_path(assessment) : require_edit_assessment_path(assessment)
  end
end
