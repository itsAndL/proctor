module Candidate::AssessmentParticipationsHelper
  def status_style(status)
    case status
    when 'completed'
      'text-lime-900 bg-lime-200'
    else
      'text-blue-900 bg-blue-200'
    end
  end

  def setup_participation_session(assessment_participation)
    session['participation_progress'] = {}
    session['participation_progress']['current_assessment_participation_id'] = assessment_participation.id
  end

  def determine_next_url(assessment_participation)
    if assessment_participation.unanswered_tests.any?
      candidate_test_path(assessment_participation.unanswered_tests.first)
    else
      checkout_candidate_assessment_participation_path(assessment_participation)
    end
  end

  def handle_setup_for_assessment_participation(assessment_participation)
    if assessment_participation.invited? || assessment_participation.invitation_clicked?
      assessment_participation.started!
    end
    setup_participation_session(assessment_participation)
  end
end
