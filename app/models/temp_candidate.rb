class TempCandidate < ApplicationRecord
  has_many :assessment_participations
  has_many :assessments, through: :assessment_participations

  validates :email, uniqueness: true, presence: true, format: { with: Devise.email_regexp, message: "is not a valid email address" }
end
