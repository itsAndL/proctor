# frozen_string_literal: true

gist_id = 'f04a8f3c30c4279d731372f1394a0b90'
custom_questions = SeedsHelper.fetch_gist_content(gist_id)

custom_questions.each do |custom_question_data|
  SeedsHelper.create_custom_question!(
    custom_question_data['title'],
    custom_question_data['attributes']
  )
end
