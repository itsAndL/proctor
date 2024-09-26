class Business < ApplicationRecord
  include Avatarable
  include Hashid::Rails

  belongs_to :user

  has_many :tests, dependent: :destroy
  has_many :custom_questions, dependent: :destroy
  has_many :assessments, dependent: :destroy
  has_many :assessment_participations, through: :assessments
  has_many :candidates, -> { distinct }, through: :assessment_participations

  validates :contact_name, :company, :bio, presence: true

  delegate :email, to: :user
end
