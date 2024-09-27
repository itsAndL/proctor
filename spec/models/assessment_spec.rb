# spec/models/assessment_spec.rb

require 'rails_helper'

RSpec.describe Assessment, type: :model do
  let!(:business) { create(:business) }
  let!(:assessment) { create(:assessment, business:) }
  let!(:questions) { create_list(:true_false_question, 20) }
  let!(:tests) { create_list(:test, 5, questions: questions.sample(5)) }
  let!(:custom_questions) { create_list(:custom_question, 5) }

  before do
    tests.each do |test|
      test.questions << questions
    end
    assessment.tests << tests
    assessment.custom_questions << custom_questions
  end

  describe '#best_candidate_score' do
    let!(:completed_participations) do
      create_list(:assessment_participation, 5, assessment:, status: :completed)
    end

    before do
      allow_any_instance_of(AssessmentParticipation).to receive(:evaluate_full_assessment).and_return(OpenStruct.new(overall_score_percentage: rand(50..100)))
    end

    it 'returns the highest score from completed participations' do
      highest_score = completed_participations.map do |participation|
        participation.evaluate_full_assessment.overall_score_percentage
      end.max.round(2)

      expect(assessment.best_candidate_score).to eq(highest_score)
    end

    it 'returns nil if there are no completed participations' do
      allow(assessment).to receive(:assessment_participations).and_return(AssessmentParticipation.none)
      expect(assessment.best_candidate_score).to be_nil
    end
  end

  describe '#candidate_pool_average' do
    let!(:completed_participations) do
      create_list(:assessment_participation, 5, assessment:, status: :completed)
    end

    before do
      allow_any_instance_of(AssessmentParticipation).to receive(:evaluate_full_assessment).and_return(OpenStruct.new(overall_score_percentage: rand(50..100)))
    end

    it 'returns the average score from completed participations' do
      total_score = completed_participations.sum do |participation|
        participation.evaluate_full_assessment.overall_score_percentage
      end

      average_score = (total_score.to_f / completed_participations.count).round(2)
      expect(assessment.candidate_pool_average).to eq(average_score)
    end

    it 'returns nil if there are no completed participations' do
      allow(assessment).to receive(:assessment_participations).and_return(AssessmentParticipation.none)
      expect(assessment.candidate_pool_average).to be_nil
    end
  end

  describe '#duration_seconds' do
    before do
      allow(assessment).to receive(:tests_duration).and_return(300) # 5 minutes
      allow(assessment).to receive(:custom_questions_duration).and_return(200) # 3 minutes 20 seconds
    end

    it 'returns the total duration of tests and custom questions' do
      expect(assessment.duration_seconds).to eq(500) # 8 minutes 20 seconds
    end
  end

  describe '#progress' do
    let!(:participations) { create_list(:assessment_participation, 3, assessment:) }

    it 'calculates the progress based on completed tests and questions' do
      allow_any_instance_of(AssessmentParticipation).to receive(:compute_test_result).and_return(OpenStruct.new(is_completed: true))
      allow_any_instance_of(AssessmentParticipation).to receive(:custom_question_completed?).and_return(true)

      progress = assessment.progress
      expect(progress).to be_between(0, 100).inclusive
    end

    it 'returns 0 if no participations exist' do
      allow(assessment).to receive(:assessment_participations).and_return(AssessmentParticipation.none)
      expect(assessment.progress).to eq(0)
    end

    it 'returns 100 if all participations are completed' do
      allow_any_instance_of(AssessmentParticipation).to receive(:completed?).and_return(true)
      expect(assessment.progress).to eq(100)
    end
  end

  describe '#last_activity' do
    it 'returns the latest activity timestamp' do
      participation_updated_at = assessment.assessment_participations.maximum(:updated_at)
      question_answer_updated_at = assessment.question_answers.maximum(:updated_at)
      custom_question_response_updated_at = assessment.custom_question_responses.maximum(:updated_at)

      last_activity_time = [participation_updated_at, question_answer_updated_at, custom_question_response_updated_at, assessment.updated_at].compact.max

      expect(assessment.last_activity).to eq(last_activity_time)
    end
  end
end
