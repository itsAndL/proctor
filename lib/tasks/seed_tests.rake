# lib/tasks/seed_tests.rake

namespace :seed do
  desc 'Custom seeding for tests from github gist'
  task tests: :environment do
    gist_id = parse_gist_flag(ARGV)

    tests_data = SeedsHelper.fetch_gist_content(gist_id)

    puts "Seeding tests from gist with id=#{gist_id}"
    tests_data.each do |test_data|
      test = SeedsHelper.create_multiple_choice_test!(test_data['title'], test_data['attributes'])
      puts "Seeded test: #{test.title}"
      test_data['questions'].each do |question|
        puts "Seeding question: #{question['question_attributes']['content']}"
        SeedsHelper.create_multiple_choice_question!(
          test.title,
          question['question_attributes'],
          question['options']
        )
      end
    end
  end

  def parse_gist_flag(argv)
    flag = argv.find { |arg| arg.start_with?('--gist=') }
    flag&.split('=', 2)&.last
  end
end
