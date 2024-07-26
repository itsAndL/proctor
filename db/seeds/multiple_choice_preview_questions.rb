# frozen_string_literal: true

file_path = Rails.root.join('db', 'seeds', 'multiple_choice_preview_questions.json')
file_content = File.read(file_path)
multiple_choice_preview_questions = JSON.parse(file_content)

multiple_choice_preview_questions.each do |question|
  SeedsHelper.create_multiple_choice_preview_question!(
    question['test_title'],
    question['question_content'],
    question['options']
  )
end
