class Candidate < ApplicationRecord
  include Avatarable
  include Hashid::Rails
  include PgSearch::Model

  after_create :update_assessment_participations

  belongs_to :user

  has_many :assessment_participations, dependent: :destroy
  has_many :assessments, through: :assessment_participations

  validates :name, presence: true
  validate :invited_to_assessment, on: :create

  delegate :email, to: :user

  scope :with_email, lambda { |email|
    joins(:user).where('LOWER(users.email) = LOWER(?)', email)
  }

  pg_search_scope :filter_by_search_query,
                  against: :name,
                  using: {
                    tsearch: { prefix: true }
                  }

  def self.find_by_email(email)
    with_email(email).first
  end

  def last_activity
    assessment_participations.map(&:last_activity).max
  end

  private

  def update_assessment_participations
    temp_candidate = TempCandidate.find_by(email:)
    return unless temp_candidate

    temp_candidate.assessment_participations.update_all(candidate_id: id, temp_candidate_id: nil)
    temp_candidate.destroy
  end

  def invited_to_assessment
    return if User.exists?(email: user.email) || TempCandidate.exists?(email: user.email)

    errors.add(:not_invited, 'You are not allowed to create an account without an invitation')
  end
end
