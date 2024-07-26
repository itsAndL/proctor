# frozen_string_literal: true

gist_id = '32a7b9b7d563441f0c27bc0f2808563d'
tests_data = SeedsHelper.fetch_gist_content(gist_id)

tests_data.each do |test_data|
  test = SeedsHelper.create_multiple_choice_test!(test_data['title'], test_data['attributes'])

  test_data['preview_questions'].each do |question_data|
    SeedsHelper.create_multiple_choice_preview_question!(
      test.title,
      question_data['question_content'],
      question_data['options']
    )
  end
end
