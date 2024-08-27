class AssessmentParticipation < ApplicationRecord
  include PgSearch::Model

  belongs_to :assessment
  belongs_to :temp_candidate, optional: true
  belongs_to :candidate, optional: true

  enum status: { invited: 0, invitation_clicked: 1, started: 2, completed: 3 }

  validates :status, presence: true
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true
  validates :assessment_id, uniqueness: {
    scope: [:candidate_id, :temp_candidate_id],
    message: "Candidate has already been invited to this assessment"
  }

  validate :candidate_or_temp_candidate_present

  pg_search_scope :filter_by_search_query,
                  associated_against: {
                    candidate: :name,
                    temp_candidate: :name
                  },
                  using: {
                    tsearch: { prefix: true }
                  }

  def avg_score
    rand(0..100)
  end

  def participant
    candidate || temp_candidate
  end

  private

  def candidate_or_temp_candidate_present
    return unless candidate.blank? && temp_candidate.blank?

    errors.add(:base, "Either candidate or temp candidate must be present")
  end
end
