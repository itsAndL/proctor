class CustomQuestionResponse < ApplicationRecord
  include Hashid::Rails

  belongs_to :assessment_participation
  belongs_to :custom_question

  has_rich_text :essay_content
  has_one_attached :file_upload
  has_one_attached :video

  validate :content_matches_question_type
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true


  private

  def content_matches_question_type
    case custom_question.type
    when 'EssayCustomQuestion'
      errors.add(:essay_content, "must be present for essay questions") if essay_content.blank?
    when 'FileUploadCustomQuestion'
      errors.add(:file_upload, "must be present for file upload questions") if file_upload.blank?
    when 'VideoCustomQuestion'
      errors.add(:video, "must be present for video questions") if video.blank?
    end
  end
end
