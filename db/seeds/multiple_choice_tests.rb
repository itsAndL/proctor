# frozen_string_literal: true

file_path = Rails.root.join('db', 'seeds', 'multiple_choice_tests.json')
file_content = File.read(file_path)
multiple_choice_tests = JSON.parse(file_content)

multiple_choice_tests.each do |test|
  SeedsHelper.create_multiple_choice_test!(test['title'], test['attributes'])
end
