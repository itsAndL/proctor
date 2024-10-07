# frozen_string_literal: true

class CustomQuestionQuery
  include LanguageHelper

  attr_reader :relation

  def initialize(relation = CustomQuestion.all, locale: I18n.locale)
    @relation = relation
    @locale = locale
  end

  def filter_by_search_query(search_query)
    return relation if search_query.blank?

    @relation = relation.filter_by_search_query(search_query)
  end

  def filter_by_categories(category_ids)
    return relation if category_ids.blank?

    @relation = relation.where(custom_question_category_id: category_ids)
  end

  def filter_by_types(types)
    return relation if types.blank?

    @relation = relation.where(type: types.map(&:camelize))
  end

  def filter_by_business(business, only_system: false, only_business: false)
    @relation = if business.present?
                  if (only_system && only_business) || (!only_system && !only_business)
                    relation.accessible_by_business(business)
                  elsif only_business
                    relation.only_business(business)
                  elsif only_system
                    relation.only_system
                  end
                else
                  relation.only_system
                end
  end

  def filter_by_language(language)
    language = map_locale_to_language(@locale) if language.blank?
    @relation = relation.where(language:)
  end

  def sorted
    @relation = relation.sorted
  end

  def execute(search_query: nil, category_ids: nil, types: nil, business: nil, only_system: false, only_business: false, language: nil)
    filter_by_search_query(search_query)
    filter_by_categories(category_ids)
    filter_by_types(types)
    filter_by_business(business, only_system:, only_business:)
    filter_by_language(language)
    sorted
    @relation
  end
end
