module AssessmentParticipationConcern
  extend ActiveSupport::Concern
  
  def find_assessment_participation_from_session
    participation_id = session.dig('participants', 'assessment_participation_id')
    AssessmentParticipation.find_by(id: participation_id)
  end
end