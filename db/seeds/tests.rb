# frozen_string_literal: true

# gist_id = '32a7b9b7d563441f0c27bc0f2808563d'
# tests_data = SeedsHelper.fetch_gist_content(gist_id)
tests_data = JSON.parse(File.read('db/seeds/data/tests.json'))

tests_data.each do |test_data|
  test = SeedsHelper.create_multiple_choice_test!(test_data['title'], test_data['attributes'])

  test_data['questions'].each do |question|
    SeedsHelper.create_multiple_choice_question!(
      test.title,
      question['question_attributes'],
      question['options']
    )
  end
end
