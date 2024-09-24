# frozen_string_literal: true

class AvatarComponent < ViewComponent::Base
  DEFAULT_AVATAR = 'avatar.png'
  MAX_FILE_SIZE = 2.megabytes
  VALID_CONTENT_TYPES = ['image/png', 'image/jpeg', 'image/jpg'].freeze

  attr_reader :avatarable, :variant, :data

  def initialize(avatarable:, variant: nil, classes: nil, data: {})
    @avatarable = avatarable
    @variant = variant
    @classes = classes
    @data = data
  end

  def classes
    [
      @classes || 'h-24 w-24 sm:h-32 sm:w-32 ring-4 ring-white',
      'object-cover rounded-full bg-gray-300'
    ]
  end

  def avatar_image_url(is_2x: false)
    return image_path(DEFAULT_AVATAR) unless valid_avatar?

    url_for(avatar_variant(is_2x))
  end

  def name
    "#{avatarable.class.name}'s"
  end

  private

  def valid_avatar?
    avatarable&.avatar&.attached? && avatarable.persisted?
  end

  def valid_avatar_file?
    avatarable.avatar.blob.byte_size <= MAX_FILE_SIZE &&
      VALID_CONTENT_TYPES.include?(avatarable.avatar.blob.content_type)
  end

  def avatar
    @avatar ||= if valid_avatar_file?
                  avatarable.avatar
                else
                  avatarable.class.find(avatarable.id).avatar
                end
  end

  def avatar_variant(is_2x)
    return avatar unless variant

    variant_name = is_2x ? "#{variant}_2x" : variant
    avatar.variant(variant_name.to_sym)
  end
end
