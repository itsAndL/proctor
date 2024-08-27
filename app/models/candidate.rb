class Candidate < ApplicationRecord
  include Avatarable
  include Hashid::Rails

  belongs_to :user

  has_many :assessment_participations, dependent: :destroy
  has_many :assessments, through: :assessment_participations

  validates :name, presence: true

  delegate :email, to: :user

  scope :with_email, lambda { |email|
    joins(:user).where("LOWER(users.email) = LOWER(?)", email)
  }

  def self.find_by_email(email)
    with_email(email).first
  end
end
