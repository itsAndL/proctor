# frozen_string_literal: true

class UserQuery
  attr_reader :relation

  def initialize(relation = User.all)
    @relation = relation
  end

  def filter_by_search_query(search_query)
    return relation if search_query.blank?

    @relation = relation.filter_by_search_query(search_query)
  end

  # Add more filter methods as needed
  # def filter_by_some_attribute(value)
  #   return relation if value.blank?
  #
  #   @relation = @relation.where(some_attribute: value)
  # end

  def sorted
    # TODO: Implement sorting logic
    # Example:
    # @relation = @relation.order(created_at: :desc)
  end

  def execute(search_query: nil)
    filter_by_search_query(search_query)
    # Call other filter methods here
    sorted
    @relation
  end
end
