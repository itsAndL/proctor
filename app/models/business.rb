class Business < ApplicationRecord
  include Avatarable
  include Hashid::Rails

  belongs_to :user

  has_many :assessments, dependent: :destroy

  validates :contact_name, :company, :bio, presence: true

  delegate :email, to: :user
end
