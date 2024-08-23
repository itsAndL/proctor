class Candidate < ApplicationRecord
  include Avatarable
  include Hashid::Rails

  belongs_to :user

  has_many :assessment_participations, dependent: :destroy
  has_many :assessments, through: :assessment_participations

  validates :name, presence: true

  delegate :email, to: :user
end
