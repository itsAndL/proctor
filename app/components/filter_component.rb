# frozen_string_literal: true

class FilterComponent < ViewComponent::Base
  def initialize(clear_path:, library:, business: nil, assessment: nil, locale: I18n.locale.to_s)
    @clear_path = clear_path
    @library = library
    @business = business
    @assessment = assessment
    @locale = locale
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
        sections: [
          show_tests_from_section,
          highlights_section,
          test_focus_section,
          test_format_section,
          test_duration_section
        ].tap { |sections| sections << language_section unless @assessment },
        placeholder: t('.search_tests'),
        filter_url: helpers.test_library_index_path
      }
    when :custom_question
      {
        sections: [
          show_questions_from_section,
          question_type_section,
          question_category_section
        ].tap { |sections| sections << language_section unless @assessment },
        placeholder: t('.search_questions'),
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
      title: t('.show_tests_from'),
      options: [
        radio_option('test_source', 'assesskit', params[:test_source] != 'my_company', 'test-source-assesskit', t('.assesskit')),
        radio_option('test_source', 'my_company', params[:test_source] == 'my_company', 'test-source-my-company', t('.my_company'))
      ],
      expanded: true
    }
  end

  def highlights_section
    {
      title: t('.highlights'),
      options: [
        highlight_option('free', 'gift', t('.free'), 60),
        highlight_option('popular', 'fire', t('.popular'), 10),
        highlight_option('new', 'sparkles', t('.new'), 123)
      ]
    }
  end

  def highlight_option(value, icon, label, count)
    {
      name: 'highlights[]',
      value:,
      checked: false,
      id: "highlight-#{value}",
      icon: helpers.svg_tag(icon, class: 'size-4', stroke_width: 2),
      label: "#{label} #{count_span(count)}"
    }
  end

  def test_focus_section
    {
      title: t('.test_focus'),
      options: TestCategory.order(:title).map.with_index(1) do |test_type, index|
        checkbox_option(
          'test_category[]',
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
      title: t('.test_format'),
      options: Test.types.map.with_index(1) do |type, index|
        checkbox_option(
          'test_type[]',
          type,
          params[:test_type]&.include?(type),
          "test-type-#{index}",
          "#{Test.human_enum_name(:type, type)} #{count_span(type.camelize.constantize.accessible_by_business(@business).count)}"
        )
      end
    }
  end

  def test_duration_section
    {
      title: t('.test_duration'),
      options: [
        checkbox_option('test-duration[]', 'less_10', false, 'test-duration-1', "#{t('.up_to_10_mins')} #{count_span(363)}"),
        checkbox_option('test-duration[]', '11_to_20', false, 'test-duration-2', "11-20 mins #{count_span(21)}"),
        checkbox_option('test-duration[]', '21_to_30', false, 'test-duration-3', "21-30 mins #{count_span(19)}"),
        checkbox_option('test-duration[]', '31_to_60', false, 'test-duration-4', "31-60 mins #{count_span(13)}")
      ]
    }
  end

  def show_questions_from_section
    {
      title: t('.show_questions_from'),
      options: [
        checkbox_option('question_source[]', 'assesskit', params[:question_source]&.include?('assesskit'), 'question-source-assesskit', t('.assesskit')),
        checkbox_option('question_source[]', 'my_company', params[:question_source]&.include?('my_company'), 'question-source-my-company', t('.my_company'))
      ],
      expanded: true
    }
  end

  def question_type_section
    {
      title: t('.question_type'),
      options: CustomQuestion.types.map.with_index(1) do |type, index|
        checkbox_option(
          'question_type[]',
          type,
          params[:question_type]&.include?(type),
          "question-type-#{index}",
          "#{CustomQuestion.human_enum_name(:type, type)} #{count_span(type.camelize.constantize.accessible_by_business(@business).count)}"
        )
      end
    }
  end

  def question_category_section
    {
      title: t('.question_category'),
      options: CustomQuestionCategory.order(:title).map.with_index(1) do |question_type, index|
        checkbox_option(
          'question_category[]',
          question_type.id,
          params[:question_category]&.include?(question_type.id.to_s),
          "test-category-#{index}",
          "#{question_type.title} #{count_span(question_type.custom_questions.accessible_by_business(@business).count)}"
        )
      end
    }
  end

  def language_section
    {
      title: t('.language'),
      options: [
        select_option('language', Assessment.languages.keys.map { |lang| [t("shared.languages.#{lang}"), lang] }, params[:language] || language_hash(@locale))
      ]
    }
  end

  def radio_option(name, value, checked, id, label)
    {
      name:,
      value:,
      checked:,
      id:,
      label:,
      data: {
        search_target: 'radio',
        action: 'change->search#submitOnCheck'
      }
    }
  end

  def checkbox_option(name, value, checked, id, label)
    {
      name:,
      value:,
      checked:,
      id:,
      label:,
      data: {
        search_target: 'checkbox',
        action: 'change->search#submitOnCheck'
      }
    }
  end

  def select_option(name, options, selected)
    {
      name:,
      options:,
      selected:,
      id: 'language-select',
      data: {
        search_target: 'select',
        action: 'change->search#submitOnChange'
      }
    }
  end

  def count_span(count)
    "<span class='text-gray-500'>(#{count})</span>"
  end

  def language_hash(locale)
    languages = {
      en: :english,
      fr: :french,
      de: :german,
      es: :spanish
    }
    languages[locale.to_sym].to_s
  end
end
