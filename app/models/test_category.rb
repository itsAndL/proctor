class TestCategory < ApplicationRecord
  validates :title, presence: true

  has_many :tests, dependent: :nullify
end
