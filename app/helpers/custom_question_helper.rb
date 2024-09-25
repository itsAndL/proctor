module CustomQuestionHelper
  CUSTOM_QUESTION_TYPE_ICONS = {
    EssayCustomQuestion => 'essay',
    FileUploadCustomQuestion => 'upload',
    VideoCustomQuestion => 'video',
    MultipleChoiceCustomQuestion => 'checklist'
  }.freeze

  def custom_question_type_icon(custom_question)
    CUSTOM_QUESTION_TYPE_ICONS[custom_question.class]
  end
end
