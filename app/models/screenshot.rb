class Screenshot < ApplicationRecord
  belongs_to :assessment_participation

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_fill: [64, 64]
    attachable.variant :preview, resize_to_limit: [300, 300]
    attachable.variant :full, resize_to_limit: [1024, 1024]
  end

  validates :image, attached: true

  def thumb_url
    Rails.application.routes.url_helpers.rails_blob_path(image.variant(:thumb), only_path: true)
  end

  def preview_url
    Rails.application.routes.url_helpers.rails_blob_path(image.variant(:preview), only_path: true)
  end

  def full_url
    Rails.application.routes.url_helpers.rails_blob_path(image.variant(:full), only_path: true)
  end
end
