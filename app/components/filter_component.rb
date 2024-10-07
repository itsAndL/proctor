# frozen_string_literal: true

class FilterComponent < ViewComponent::Base
  include LanguageHelper

  def initialize(records, clear_path:, business: nil, assessment: nil, locale: I18n.locale.to_s)
    @records = records
    @clear_path = clear_path
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
    case @records.table_name
    when 'tests'
      test_categories = TestCategory.joins(:tests).where(tests: { language: }).distinct
      sections = [
        show_tests_from_section,
        # highlights_section,
        test_format_section,
        test_duration_section
      ]
      sections.insert(1, test_focus_section(test_categories)) if test_categories.any?
      sections << language_section unless @assessment

      {
        sections:,
        placeholder: t('.search_tests'),
        filter_url: helpers.test_library_index_path
      }
    when 'custom_questions'
      question_categories = CustomQuestionCategory.joins(:custom_questions).where(custom_questions: { language: }).distinct
      sections = [
        show_questions_from_section,
        question_type_section
      ]
      sections << question_category_section(question_categories) if question_categories.any?
      sections << language_section unless @assessment

      {
        sections:,
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
        radio_option('test_source', 'assesskit', params[:test_source] != 'my_company', 'test-source-assesskit', 'AssessKit'),
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

  def test_focus_section(categories)
    {
      title: t('.test_focus'),
      options: categories.order(:title).map.with_index(1) do |test_type, index|
        count = @records.joins(:test_category).where(test_categories: { id: test_type.id }).accessible_by_business(@business).active.count
        checkbox_option(
          'test_category[]',
          test_type.id,
          params[:test_category]&.include?(test_type.id.to_s),
          "test-category-#{index}",
          "#{test_type.title} #{count_span(count)}"
        )
      end
    }
  end

  def test_format_section
    {
      title: t('.test_format'),
      options: Test.types.map.with_index(1) do |type, index|
        count = @records.where(type: type.camelize).accessible_by_business(@business).count
        checkbox_option(
          'test_type[]',
          type,
          params[:test_type]&.include?(type),
          "test-type-#{index}",
          "#{Test.human_enum_name(:type, type)} #{count_span(count)}"
        )
      end
    }
  end

  def test_duration_section
    durations = [
      { range: 'less_10', label: t('.up_to_10_mins'), seconds: 0..600 },
      { range: '11_to_20', label: '11-20 mins', seconds: 601..1200 },
      { range: '21_to_30', label: '21-30 mins', seconds: 1201..1800 },
      { range: '31_to_60', label: '31-60 mins', seconds: 1801..3600 }
    ]

    {
      title: t('.test_duration'),
      options: durations.map.with_index(1) do |duration, index|
        count = @records.accessible_by_business(@business).where(duration_seconds: duration[:seconds]).count
        checkbox_option(
          'test_duration[]',
          duration[:range],
          params[:test_duration]&.include?(duration[:range]),
          "test-duration-#{index}",
          "#{duration[:label]} #{count_span(count)}"
        )
      end
    }
  end

  def show_questions_from_section
    {
      title: t('.show_questions_from'),
      options: [
        checkbox_option('question_source[]', 'assesskit', params[:question_source]&.include?('assesskit'), 'question-source-assesskit', 'AssessKit'),
        checkbox_option('question_source[]', 'my_company', params[:question_source]&.include?('my_company'), 'question-source-my-company', t('.my_company'))
      ],
      expanded: true
    }
  end

  def question_type_section
    {
      title: t('.question_type'),
      options: CustomQuestion.types.map.with_index(1) do |type, index|
        count = @records.where(type: type.camelize).accessible_by_business(@business).count
        checkbox_option(
          'question_type[]',
          type,
          params[:question_type]&.include?(type),
          "question-type-#{index}",
          "#{CustomQuestion.human_enum_name(:type, type)} #{count_span(count)}"
        )
      end
    }
  end

  def question_category_section(categories)
    {
      title: t('.question_category'),
      options: categories.order(:title).map.with_index(1) do |question_type, index|
        count = @records.joins(:custom_question_category).where(custom_question_categories: { id: question_type.id }).accessible_by_business(@business).count
        checkbox_option(
          'question_category[]',
          question_type.id,
          params[:question_category]&.include?(question_type.id.to_s),
          "question-category-#{index}",
          "#{question_type.title} #{count_span(count)}"
        )
      end
    }
  end

  def language_section
    {
      title: t('.language'),
      options: [
        select_option('language', Assessment.languages.keys.map { |lang| [t("shared.languages.#{lang}"), lang] }, language)
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

  def language
    params[:language] || map_locale_to_language(@locale)
  end
end
