FactoryBot.define do
  factory :option do
    correct { [true, false].sample }
    optionable_type { 'Question' }
    association :optionable, factory: :question
  end
end
