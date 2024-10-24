# lib/tasks/seed_tests.rake

namespace :seed do
  desc 'Custom seeding for custom questions from github gist'
  task custom_questions: :environment do
    gist_id = parse_gist_flag(ARGV)

    custom_questions_data = SeedsHelper.fetch_gist_content(gist_id)

    puts "Seeding custom questions from gist with id=#{gist_id}"
    custom_questions_data.each do |custom_question_data|
      SeedsHelper.create_custom_question!(
        custom_question_data['title'],
        custom_question_data['attributes']
      )
    end
  end

  def parse_gist_flag(argv)
    flag = argv.find { |arg| arg.start_with?('--gist=') }
    flag&.split('=', 2)&.last
  end
end
