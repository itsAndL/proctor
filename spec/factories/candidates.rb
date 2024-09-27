FactoryBot.define do
  factory :candidate do
    user { create(:user) }
    name { Faker::Name.name }
    avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'assets', 'harvard.jfif')) }
  end
end
