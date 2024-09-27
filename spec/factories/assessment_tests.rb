FactoryBot.define do
  factory :assessment_test do
    association :assessment
    association :test
    position { Faker::Number.between(from: 1, to: 10) }
  end
end
