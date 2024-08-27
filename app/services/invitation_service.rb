# app/services/invitation_service.rb

class InvitationService
  class << self
    def invite_participant(assessment, email, name = nil)
      participant = find_or_create_participant(email, name)
      participation = create_assessment_participation(assessment, participant)

      if participation.persisted? && participation.invited?
        AssessmentMailerJob.perform_async(participation.id)
      end

      participation
    end

    private

    def find_or_create_participant(email, name = nil)
      candidate = Candidate.joins(:user).find_by(users: { email: email })
      return candidate if candidate

      temp_candidate = TempCandidate.find_or_create_by!(email: email) do |tc|
        tc.name = name if name.present?
      end

      if temp_candidate.name.blank? && name.present?
        temp_candidate.update(name: name)
      end

      temp_candidate
    end

    def create_assessment_participation(assessment, participant)
      AssessmentParticipation.find_or_create_by!(
        assessment: assessment,
        candidate: participant.is_a?(Candidate) ? participant : nil,
        temp_candidate: participant.is_a?(TempCandidate) ? participant : nil
      ) do |p|
        p.status = :invited if p.new_record?
      end
    end
  end
end
