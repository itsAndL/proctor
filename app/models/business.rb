class Business < ApplicationRecord
  include Avatarable
  include Hashid::Rails

  belongs_to :user

  has_many :tests, dependent: :destroy
  has_many :custom_questions, dependent: :destroy
  has_many :assessments, dependent: :destroy
  has_many :assessment_participations, through: :assessments
  has_many :candidates, -> { distinct }, through: :assessment_participations

  validates :company, presence: true
  # validates :avatar, attached: true, on: :create

  delegate :email, to: :user

  def candidates_for_search
    Candidate.where(id: candidates.pluck(:id))
  end
end
