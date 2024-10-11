class TempCandidate < ApplicationRecord
  has_many :assessment_participations
  has_many :assessments, through: :assessment_participations

  validates :email, uniqueness: true, presence: true, format: { with: Devise.email_regexp }

  before_validation :downcase_email

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
