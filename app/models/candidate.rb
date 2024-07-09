class Candidate < ApplicationRecord
  include Avatarable
  include Hashid::Rails

  belongs_to :user

  validates :name, presence: true
end
