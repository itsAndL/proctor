# frozen_string_literal: true

class FilterComponent < ViewComponent::Base
  def initialize(clear_path:, library:, business: nil, assessment: nil)
    @clear_path = clear_path
    @library = library
    @business = business
    @assessment = assessment
  end

  def filter_sections
    library_config[:sections]
  end

  def placeholder
    library_config[:placeholder]
  end

  def filter_url
    library_config[:filter_url]
  end

  private

  def library_config
    case @library
    when :test
      {
        sections: [show_tests_from_section, highlights_section, test_focus_section, test_format_section, test_duration_section],
        placeholder: 'Search tests',
        filter_url: helpers.test_library_index_path
      }
    when :custom_question
      {
        sections: [show_questions_from_section, question_type_section, question_category_section],
        placeholder: 'Search questions',
        filter_url: helpers.custom_question_library_index_path
      }
    else
      {
        sections: [],
        placeholder: '',
        filter_url: ''
      }
    end
  end

  def show_tests_from_section
    {
      title: "Show tests from",
      options: [
        radio_option("test_source", "assesskit", params[:test_source] != "my_company", "test-source-assesskit", "AssessKit"),
        radio_option("test_source", "my_company", params[:test_source] == "my_company", "test-source-my-company", "My company")
      ],
      expanded: true
    }
  end

  def highlights_section
    {
      title: "Highlights",
      options: [
        highlight_option("free", "gift", "Free", 60),
        highlight_option("popular", "fire", "Popular", 10),
        highlight_option("new", "sparkles", "New", 123)
      ]
    }
  end

  def highlight_option(value, icon, label, count)
    {
      name: "highlights[]",
      value: value,
      checked: false,
      id: "highlight-#{value}",
      icon: helpers.svg_tag(icon, class: "size-4", stroke_width: 2),
      label: "#{label} #{count_span(count)}"
    }
  end

  def test_focus_section
    {
      title: "Test focus",
      options: TestCategory.order(:title).map.with_index(1) do |test_type, index|
        checkbox_option(
          "test_category[]",
          test_type.id,
          params[:test_category]&.include?(test_type.id.to_s),
          "test-category-#{index}",
          "#{test_type.title} #{count_span(test_type.tests.accessible_by_business(@business).active.count)}"
        )
      end
    }
  end

  def test_format_section
    {
      title: "Test format",
      options: Test.types.map.with_index(1) do |type, index|
        checkbox_option(
          "test_type[]",
          type,
          params[:test_type]&.include?(type),
          "test-type-#{index}",
          "#{t(".types.test.#{type}", default: type.humanize)} #{count_span(type.camelize.constantize.accessible_by_business(@business).count)}"
        )
      end
    }
  end

  def test_duration_section
    {
      title: "Test duration",
      options: [
        checkbox_option("test-duration[]", "less_10", false, "test-duration-1", "Up to 10 mins #{count_span(363)}"),
        checkbox_option("test-duration[]", "11_to_20", false, "test-duration-2", "11-20 mins #{count_span(21)}"),
        checkbox_option("test-duration[]", "21_to_30", false, "test-duration-3", "21-30 mins #{count_span(19)}"),
        checkbox_option("test-duration[]", "31_to_60", false, "test-duration-4", "31-60 mins #{count_span(13)}"),
      ]
    }
  end

  def show_questions_from_section
    {
      title: "Show questions from",
      options: [
        checkbox_option("question_source[]", "assesskit", params[:question_source]&.include?("assesskit"), "question-source-assesskit", "AssessKit"),
        checkbox_option("question_source[]", "my_company", params[:question_source]&.include?("my_company"), "question-source-my-company", "My company")
      ],
      expanded: true
    }
  end

  def question_type_section
    {
      title: "Question type",
      options: CustomQuestion.types.map.with_index(1) do |type, index|
        checkbox_option(
          "question_type[]",
          type,
          params[:question_type]&.include?(type),
          "question-type-#{index}",
          "#{t(".types.custom_question.#{type}", default: type.humanize)} #{count_span(type.camelize.constantize.accessible_by_business(@business).count)}"
        )
      end
    }
  end

  def question_category_section
    {
      title: "Question category",
      options: CustomQuestionCategory.order(:title).map.with_index(1) do |question_type, index|
        checkbox_option(
          "question_category[]",
          question_type.id,
          params[:question_category]&.include?(question_type.id.to_s),
          "test-category-#{index}",
          "#{question_type.title} #{count_span(question_type.custom_questions.accessible_by_business(@business).count)}"
        )
      end
    }
  end

  def radio_option(name, value, checked, id, label)
    {
      name: name,
      value: value,
      checked: checked,
      id: id,
      label: label,
      data: {
        search_target: "radio",
        action: "change->search#submitOnCheck"
      }
    }
  end

  def checkbox_option(name, value, checked, id, label)
    {
      name: name,
      value: value,
      checked: checked,
      id: id,
      label: label,
      data: {
        search_target: "checkbox",
        action: "change->search#submitOnCheck"
      }
    }
  end

  def count_span(count)
    "<span class='text-gray-500'>(#{count})</span>"
  end
end
