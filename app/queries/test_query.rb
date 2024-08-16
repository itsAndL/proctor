# frozen_string_literal: true

class TestQuery
  attr_reader :relation

  def initialize(relation = Test.all)
    @relation = relation
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

  def sorted
    @relation = relation.order(:position)
  end

  def execute(search_query: nil, category_ids: nil, types: nil)
    filter_by_search_query(search_query)
    filter_by_categories(category_ids)
    filter_by_types(types)
    sorted
    @relation
  end
end
