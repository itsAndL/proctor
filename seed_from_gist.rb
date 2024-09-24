require 'json'
require 'fileutils'

# Define your Gist IDs and target paths
gists = {
  'f04a8f3c30c4279d731372f1394a0b90' => 'custom_questions.json',
  '32a7b9b7d563441f0c27bc0f2808563d' => 'tests.json'
}

# Define the path where the JSON files will be saved
seeds_path = 'db/seeds/data'

# Ensure the seeds directory exists
FileUtils.mkdir_p(seeds_path)

# Authenticate with GitHub CLI (make sure you're already authenticated)

# Download and save each Gist
gists.each do |gist_id, file_name|
  puts "Fetching Gist #{gist_id}..."

  # Fetch the Gist content and save to file
  gist_content = `gh gist view #{gist_id}`
  # remove first 2 line from gist_content
  gist_content = gist_content.split("\n")[2..].join("\n")
  File.open(File.join(seeds_path, file_name), 'w') do |file|
    file.write(gist_content)
  end

  puts "Saved #{file_name} to #{seeds_path}."
end

# Seed the database
puts 'Seeding the database...'
system('rails db:seed')

puts 'Database seeded successfully.'
