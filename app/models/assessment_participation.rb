class AssessmentParticipation < ApplicationRecord
  include PgSearch::Model

  belongs_to :assessment
  belongs_to :temp_candidate, optional: true
  belongs_to :candidate, optional: true

  enum status: { invited: 0, invitation_clicked: 1, started: 2, completed: 3 }

  validates :status, presence: true
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true

  # You might want to add a validation to ensure either temp_candidate or candidate is present
  validate :temp_candidate_or_candidate_present

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

  def temp_candidate_or_candidate_present
    return unless temp_candidate.blank? && candidate.blank?

    errors.add(:base, "Either temp candidate or candidate must be present")
  end
end
