# frozen_string_literal: true

class TestQuery
  include LanguageHelper

  attr_reader :relation

  def initialize(relation = Test.all, locale: I18n.locale)
    @relation = relation
    @locale = locale
  end

  def filter_by_search_query(search_query)
    return relation if search_query.blank?

    @relation = relation.filter_by_search_query(search_query)
  end

  def filter_by_categories(category_ids)
    return relation if category_ids.blank?

    @relation = relation.where(test_category_id: category_ids)
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

  def filter_by_duration(durations)
    return relation if durations.blank?

    @relation = relation.where(duration_seconds: duration_ranges(durations))
  end

  def active
    @relation = relation.active
  end

  def sorted
    @relation = relation.sorted
  end

  def execute(search_query: nil, category_ids: nil, types: nil, business: nil, only_system: false, only_business: false, language: nil, durations: nil)
    filter_by_search_query(search_query)
    filter_by_categories(category_ids)
    filter_by_types(types)
    filter_by_business(business, only_system:, only_business:)
    filter_by_language(language)
    filter_by_duration(durations)
    active
    sorted
    @relation
  end

  private

  def duration_ranges(durations)
    ranges = {
      'less_10' => 0..600,
      '11_to_20' => 601..1200,
      '21_to_30' => 1201..1800,
      '31_to_60' => 1801..3600
    }

    durations.map { |duration| ranges[duration] }.compact
  end
end
