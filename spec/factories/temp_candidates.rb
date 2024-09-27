FactoryBot.define do
  factory :temp_candidate do
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
