FactoryBot.define do
  factory :custom_question_category do
    title { Faker::Lorem.sentence(word_count: 3) }
  end
end
