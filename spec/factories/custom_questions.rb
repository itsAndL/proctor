FactoryBot.define do
  factory :custom_question do
    title { Faker::Lorem.sentence(word_count: 3) }
    relevancy { Faker::Lorem.paragraph }
    look_for { Faker::Lorem.paragraph }
    duration_seconds { Faker::Number.between(from: 1, to: 3600) }
    type { %w[EssayCustomQuestion FileUploadCustomQuestion VideoCustomQuestion MultipleChoiceCustomQuestion].sample }
    position { Faker::Number.between(from: 1, to: 10) }
    association :custom_question_category
    business { Business.first || create(:business) }
    language { CustomQuestion.languages.keys.sample }
    content { Faker::Lorem.paragraph(sentence_count: 3) }
  end
end
