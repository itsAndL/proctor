class CustomQuestionResponse < ApplicationRecord
  include Hashid::Rails
  include TimeTracking

  belongs_to :assessment_participation
  belongs_to :custom_question

  delegate :duration_seconds, to: :custom_question

  has_rich_text :essay_content
  has_one_attached :file_upload
  has_one_attached :video

  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 },
                     allow_nil: true
  validates :file_upload, max_file_size: 400.megabytes, content_type: %w[
    text/csv
    application/vnd.ms-excel
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
    application/msword
    text/plain
    application/vnd.ms-powerpoint
    application/vnd.openxmlformats-officedocument.presentationml.presentation
    application/vnd.oasis.opendocument.presentation
    application/vnd.apple.keynote
    application/pdf
    image/png
    image/jpeg
    image/vnd.adobe.photoshop
    image/bmp
    image/gif
  ]

  enum status: { pending: 0, started: 1, completed: 2 }
end
