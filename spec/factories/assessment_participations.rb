FactoryBot.define do
  factory :assessment_participation do
    assessment { Assessment.first || create(:assessment) }
    candidate {  create(:candidate) }
    temp_candidate { create(:temp_candidate) }
    status { AssessmentParticipation.statuses.keys.sample }
    rating { 1 }
    webcam_enabled { false }
    fullscreen_always_active { false }
    mouse_always_in_window { false }
    notes { Faker::Lorem.sentence }
  end
end
