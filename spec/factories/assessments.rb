FactoryBot.define do
  factory :assessment do
    title { Faker::Lorem.sentence(word_count: 3) }
    language { Assessment.languages.keys.sample }
    business { Business.first || create(:business) }
    public_link_token { SecureRandom.hex(10) }
    public_link_active { [true, false].sample }

    after(:build) do |assessment|
      assessment.assessment_tests << create_list(:assessment_test, 5, assessment:)
      assessment.assessment_custom_questions << create_list(:assessment_custom_question, 5, assessment:)
    end
  end
end
