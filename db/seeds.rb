# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "seeds_helper"

def seed(file)
  load Rails.root.join('db', 'seeds', "#{file}.rb")
  puts "Seeded #{file}"
end

puts "Seeding #{Rails.env} database..."
seed 'multiple_choice_tests'
seed 'multiple_choice_preview_questions'
puts 'Seeded database'
