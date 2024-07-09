class Business < ApplicationRecord
  include Avatarable
  include Hashid::Rails

  belongs_to :user

  validates :contact_name, :company, :bio, presence: true
end
