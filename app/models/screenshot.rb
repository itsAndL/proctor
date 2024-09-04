class Screenshot < ApplicationRecord
  belongs_to :assessment_participation

  has_one_attached :image

  validates :image, attached: true
end
