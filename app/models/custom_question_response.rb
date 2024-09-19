class CustomQuestionResponse < ApplicationRecord
  include Hashid::Rails

  belongs_to :assessment_participation
  belongs_to :custom_question

  has_rich_text :essay_content
  has_one_attached :file_upload, service:, max_file_size: 400.megabytes, content_type: %w[
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
  has_one_attached :video, service:, max_file_size: 400.megabytes 

  validate :content_matches_question_type
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 },
                     allow_nil: true

  enum status: { pending: 0, started: 1, completed: 2 }
  after_find :set_completed_if_time_exceeded
  before_save :set_timestamps

  def calculate_time_taken
    return -1 if infinite_time?

    (Time.current.to_i - (started_at || 0).to_i)
  end

  def total_time_taken
    return 0 if infinite_time? || started_at.nil? || completed_at.nil?

    (completed_at - started_at).to_i
  end

  def more_time?
    custom_question.duration_seconds > calculate_time_taken
  end

  def duration_seconds
    custom_question.duration_seconds
  end

  def infinite_time?
    custom_question.duration_seconds.nil? || custom_question.duration_seconds.zero?
  end

  def duration_left
    return 0 if infinite_time?

    duration_seconds - calculate_time_taken
  end

  private

  def set_completed_if_time_exceeded
    return if infinite_time? || pending? || completed? || duration_left.positive?
    
    update_column(:status, 'completed') # it's important to use update_column to skip validations
  end

  def set_timestamps
    return unless status_changed?

    self.started_at = Time.current if status == 'started' && started_at.nil?
    self.completed_at = Time.current if status == 'completed' && completed_at.nil?
  end

  def content_matches_question_type
    return unless status == 'completed'

    case custom_question.type
    when 'EssayCustomQuestion'
      errors.add(:essay_content, 'must be present for essay questions') if essay_content.blank?
    when 'FileUploadCustomQuestion'
      errors.add(:file_upload, 'must be present for file upload questions') if file_upload.blank?
    when 'VideoCustomQuestion'
      errors.add(:video, 'must be present for video questions') if video.blank?
    end
  end
end
