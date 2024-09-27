FactoryBot.define do
  factory :business do
    user { create(:user) }
    contact_name { Faker::Name.name }
    contact_role { Faker::Job.title }
    company { Faker::Company.name }
    bio { Faker::Lorem.paragraph }
    website { Faker::Internet.url(host: 'example.com') }
    avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'assets', 'harvard.jfif')) }
  end
end
