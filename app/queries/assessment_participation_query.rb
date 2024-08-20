# frozen_string_literal: true

class AssessmentParticipationQuery
  attr_reader :relation

  def initialize(relation = AssessmentParticipation.all)
    @relation = relation
  end

  def filter_by_search_query(search_query)
    return relation if search_query.blank?

    @relation = relation.filter_by_search_query(search_query)
  end

  def filter_by_status(status)
    return relation if status.blank?

    @relation = @relation.where(status:)
  end

  def sorted
    @relation = @relation.order(created_at: :desc)
  end

  def execute(search_query: nil, status: nil)
    filter_by_search_query(search_query)
    filter_by_status(status)
    sorted
    @relation
  end
end
