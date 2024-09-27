FactoryBot.define do
  factory :test do
    title { Faker::Book.title }
    overview { Faker::Lorem.sentence(word_count: 10) }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    level { Test.levels.keys.sample }
    covered_skills { [Faker::Educator.subject, Faker::Game.genre, Faker::Music.instrument] }
    relevancy { Faker::Lorem.sentence(word_count: 5) }
    type { 'MultipleChoiceTest' }
    association :test_category
    position { Faker::Number.between(from: 1, to: 100) }
    active { true }
    business { Business.first || create(:business) }
    language { Test.languages.keys.sample }
    questions_to_answer { Faker::Number.between(from: 5, to: 20) }
    duration_seconds { Faker::Number.between(from: 600, to: 7200) }

    trait :inactive do
      active { false }
    end

    trait :advanced_level do
      level { :advanced }
    end

    trait :with_questions do
      after(:create) do |test|
        create_list(:question, 5, tests: [test])
      end
    end
  end
end
