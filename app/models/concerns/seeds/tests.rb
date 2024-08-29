module Seeds
  module Tests
    def create_multiple_choice_test!(title, attributes = {})
      ActiveRecord::Base.transaction do
        MultipleChoiceTest.find_or_create_by!(title:) do |test|
          test.attributes = attributes
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Failed to create MultipleChoiceTest: #{e.message}")
      raise
    end

    def create_multiple_choice_question!(test_title, question_attributes, options)
      ActiveRecord::Base.transaction do
        test = find_test(test_title)
        return unless test

        question = find_or_build_question(
          test,
          question_attributes['type'],
          question_attributes['content'],
          question_attributes['preview'],
          question_attributes['duration_seconds']
        )
        associate_question_with_test(question, test)
        update_options(question, options)

        question.save!
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Failed to create MultipleChoicePreviewQuestion: #{e.message}")
      raise
    end

    private

    def find_test(test_title)
      Test.find_by(title: test_title).tap do |test|
        Rails.logger.warn("Test not found with title: #{test_title}") unless test
      end
    end

    def find_or_build_question(test, type, content, preview, duration_seconds)
      find_similar_question(type, content) || build_new_question(test, type, content, preview, duration_seconds)
    end

    def find_similar_question(type, content)
      plain_content = plain_text(content)
      Question.joins(:rich_text_content)
              .where(type: "#{type.camelcase}Question")
              .find { |question| plain_text(question.content.body) == plain_content }
    end

    def build_new_question(test, type, content, preview, duration_seconds)
      test.questions.build(
        content: content,
        type: "#{type.camelcase}Question",
        preview: preview,
        duration_seconds: duration_seconds
      )
    end

    def associate_question_with_test(question, test)
      question.test_questions.find_or_initialize_by(test:)
    end

    def update_options(question, options)
      update_existing_options(question, options)
      add_new_options(question, options)
      remove_obsolete_options(question, options)
    end

    def update_existing_options(question, options)
      question.options.each do |existing_option|
        matching_option = find_matching_option(options, existing_option)
        existing_option.assign_attributes(correct: matching_option['correct']) if matching_option
      end
    end

    def add_new_options(question, options)
      options.each do |option_attrs|
        next if option_exists?(question, option_attrs['content'])

        question.options.build(
          content: option_attrs['content'],
          correct: option_attrs['correct']
        )
      end
    end

    def remove_obsolete_options(question, options)
      question.options.each do |option|
        option.mark_for_destruction unless option_in_new_options?(option, options)
      end
    end

    def find_matching_option(options, existing_option)
      options.find { |opt| plain_text(opt['content']) == plain_text(existing_option.content.body) }
    end

    def option_exists?(question, content)
      question.options.any? { |opt| plain_text(opt.content.body) == plain_text(content) }
    end

    def option_in_new_options?(option, options)
      options.any? { |opt| plain_text(opt['content']) == plain_text(option.content.body) }
    end

    def plain_text(content)
      ActionText::RichText.new(body: content).to_plain_text.strip.downcase
    end
  end
end
