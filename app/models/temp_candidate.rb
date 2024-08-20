class TempCandidate < ApplicationRecord
  has_many :assessment_participations, dependent: :destroy
  has_many :assessments, through: :assessment_participations

  validates :name, presence: true
  validates :email, presence: true, format: { with: Devise.email_regexp, message: "is not a valid email address" }
end
