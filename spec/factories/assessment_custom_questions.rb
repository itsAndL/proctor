FactoryBot.define do
  factory :assessment_custom_question do
    association :assessment
    association :custom_question
    position { Faker::Number.between(from: 1, to: 10) }
  end
end
