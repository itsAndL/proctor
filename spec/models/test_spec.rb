# spec/models/test_spec.rb
require 'rails_helper'

RSpec.describe Test, type: :model do
  let(:test_category) { create(:test_category, title: 'Technical') }
  let(:test) { create(:test, test_category:, questions_to_answer: 3) }

  describe '#category' do
    it 'returns the title of the associated test category' do
      expect(test.category).to eq 'Technical'
    end

    it 'returns nil if test category is not present' do
      test.update(test_category: nil)
      expect(test.category).to be_nil
    end
  end

  describe '#selected_questions' do
    let!(:questions) { create_list(:question, 5, preview: false) }

    before do
      test.questions << questions
    end

    it 'returns random active, non-preview questions up to the limit of questions_to_answer' do
      selected_questions = test.selected_questions
      expect(selected_questions.count).to eq(3)
      expect(selected_questions).to all(be_active)
      expect(selected_questions).to all(have_attributes(preview: false))
    end

    it 'does not return more questions than available active non-preview questions' do
      test.update(questions_to_answer: 10)
      expect(test.selected_questions.count).to eq(5)
    end
  end

  describe '#preview_questions' do
    let!(:preview_questions) { create_list(:question, 3, preview: true) }

    before do
      preview_questions.each_with_index do |question, index|
        test.test_questions.create(question:, position: index + 1)
      end
    end

    it 'returns active preview questions ordered by position' do
      expect(test.preview_questions.map(&:id)).to eq(preview_questions.map(&:id))
    end
  end

  describe '.types' do
    it 'returns the available test types' do
      expect(Test.types).to match_array(%w[coding_test multiple_choice_test questionnaire_test])
    end
  end

  describe '#next_preview' do
    let!(:preview_questions) { create_list(:question, 2, preview: true, active: true) }

    before do
      preview_questions.each_with_index do |question, index|
        test.test_questions.create(question:, position: index + 1)
      end
    end

    it 'returns the next preview question in order' do
      expect(test.next_preview(test.test_questions.first)).to eq(test.test_questions.second.question)
    end

    it 'returns nil if there is no next preview question' do
      expect(test.next_preview(test.test_questions.second)).to be_nil
    end
  end

  describe '#previous_preview' do
    let!(:preview_questions) { create_list(:question, 2, preview: true, active: true) }

    before do
      preview_questions.each_with_index do |question, index|
        test.test_questions.create(question:, position: index + 1)
      end
    end

    it 'returns the previous preview question in order' do
      expect(test.previous_preview(test.test_questions.second)).to eq(test.test_questions.first.question)
    end

    it 'returns nil if there is no previous preview question' do
      expect(test.previous_preview(test.test_questions.first)).to be_nil
    end
  end

  describe '#next_non_preview' do
    let!(:non_preview_questions) { create_list(:question, 2, preview: false, active: true) }

    before do
      non_preview_questions.each_with_index do |question, index|
        test.test_questions.create(question:, position: index + 1)
      end
    end

    it 'returns the next non-preview question in order' do
      expect(test.next_non_preview(test.test_questions.first)).to eq(test.test_questions.second.question)
    end

    it 'returns nil if there is no next non-preview question' do
      expect(test.next_non_preview(test.test_questions.second)).to be_nil
    end
  end

  describe '#previous_non_preview' do
    let!(:non_preview_questions) { create_list(:question, 2, preview: false, active: true) }

    before do
      non_preview_questions.each_with_index do |question, index|
        test.test_questions.create(question:, position: index + 1)
      end
    end

    it 'returns the previous non-preview question in order' do
      expect(test.previous_non_preview(test.test_questions.second)).to eq(test.test_questions.first.question)
    end

    it 'returns nil if there is no previous non-preview question' do
      expect(test.previous_non_preview(test.test_questions.first)).to be_nil
    end
  end
end
