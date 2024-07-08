class Business < ApplicationRecord
  belongs_to :user

  has_one_attached :avatar

  before_save :anonymize_avatar_filename

  private

  def anonymize_avatar_filename
    return unless avatar.attached?

    avatar.blob.filename = "avatar#{avatar.filename.extension_with_delimiter}"
  end
end
