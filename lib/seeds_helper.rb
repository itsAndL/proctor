module SeedsHelper
  class << self
    def create_multiple_choice_test!(title, attributes = {})
      MultipleChoiceTest.find_or_create_by!(title:) do |test|
        test.attributes = attributes
      end
    end

    def create_multiple_choice_preview_question!(test_title, question_content)
      test = Test.find_by(title: test_title)
      return unless test

      question = find_or_create_question(test, question_content)
      associate_question_with_test(test, question)
    end

    private

    def find_or_create_question(test, question_content)
      find_similar_question(question_content) || create_new_question(test, question_content)
    end

    def find_similar_question(content)
      # Convert the content to plain text for comparison
      plain_content = ActionText::RichText.new(body: content).to_plain_text.strip.downcase

      Question.joins(:rich_text_content)
              .where(type: 'MultipleChoiceQuestion')
              .find do |question|
        question_content = question.content.body.to_plain_text.strip.downcase
        question_content == plain_content
      end
    end

    def create_new_question(test, question_content)
      test.questions.create!(
        content: question_content,
        type: 'MultipleChoiceQuestion',
        preview: true
      )
    end

    def associate_question_with_test(test, question)
      test.test_questions.find_or_create_by!(question:)
    end
  end
end
