FactoryBot.define do
  factory :question do
    preview { true }
    active { true }
    is_correct { true }
    type { %w[MultipleChoiceQuestion MultipleResponseQuestion ShortTextQuestion TrueFalseQuestion].sample }

    content { Faker::Lorem.sentence(word_count: 10) }

    after(:build) do |question|
      question.options = build_list(:option, 5) if question.is_a?(MultipleChoiceQuestion) || question.is_a?(MultipleResponseQuestion)
    end

    trait :correct do
      is_correct { true }
    end

    trait :incorrect do
      is_correct { false }
    end

    trait :inactive do
      active { false }
    end

    trait :multiple_choice do
      type { 'MultipleChoiceQuestion' }
    end

    trait :multiple_response do
      type { 'MultipleResponseQuestion' }
    end

    trait :short_text do
      type { 'ShortTextQuestion' }
    end

    trait :true_false do
      type { 'TrueFalseQuestion' }
    end

    factory :multiple_choice_question, traits: [:multiple_choice]
    factory :multiple_response_question, traits: [:multiple_response]
    factory :short_text_question, traits: [:short_text]
    factory :true_false_question, traits: [:true_false]
  end
end
