class InvitationService
  class << self
    def invite_participant(assessment, email, name = nil)
      participant = find_or_create_participant(email, name)
      participation, is_new = find_or_create_assessment_participation(assessment, participant)

      AssessmentMailerJob.perform_async(participation.id) if is_new

      OpenStruct.new(success?: true, participation: participation, is_new: is_new)
    rescue => e
      OpenStruct.new(success?: false, error_message: "Failed to invite participant: #{e.message}")
    end

    def bulk_invite(assessment, candidates)
      candidates.each do |candidate|
        invite_participant(assessment, candidate[:email] || candidate['email'], candidate[:name] || candidate['name'])
      end
    end

    def candidate_exists?(assessment, email)
      participant = find_participant(email)
      return false unless participant

      AssessmentParticipation.exists?(
        assessment: assessment,
        candidate: participant.is_a?(Candidate) ? participant : nil,
        temp_candidate: participant.is_a?(TempCandidate) ? participant : nil
      )
    end

    private

    def find_participant(email)
      Candidate.find_by_email(email) || TempCandidate.find_by(email: email)
    end

    def find_or_create_participant(email, name = nil)
      candidate = Candidate.find_by_email(email)
      return candidate if candidate

      temp_candidate = TempCandidate.find_or_create_by!(email: email) do |tc|
        tc.name = name if name.present?
      end

      if temp_candidate.name.blank? && name.present?
        temp_candidate.update(name: name)
      end

      temp_candidate
    end

    def find_or_create_assessment_participation(assessment, participant)
      participation = AssessmentParticipation.find_by(
        assessment: assessment,
        candidate: participant.is_a?(Candidate) ? participant : nil,
        temp_candidate: participant.is_a?(TempCandidate) ? participant : nil
      )

      if participation
        [participation, false]
      else
        new_participation = AssessmentParticipation.create!(
          assessment: assessment,
          candidate: participant.is_a?(Candidate) ? participant : nil,
          temp_candidate: participant.is_a?(TempCandidate) ? participant : nil,
          status: :invited
        )
        [new_participation, true]
      end
    end
  end
end
