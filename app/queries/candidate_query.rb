# frozen_string_literal: true

class CandidateQuery
  attr_reader :relation

  def initialize(relation: Candidate.all, user: current_)
    policy = CandidatePolicy.new(user:)
    @relation = policy.authorized_scope(relation)
  end

  def filter_by_search_query(search_query)
    return relation if search_query.blank?

    @relation = relation.filter_by_search_query(search_query)
  end

  def filter_by_assessment(assessment_id)
    return relation if assessment_id.blank?

    @relation = relation.joins(:assessment_participations)
                        .where(assessment_participations: { assessment_id: })
  end

  def sorted
    @relation = @relation.order(created_at: :desc)
  end

  def execute(search_query: nil, assessment_id: nil)
    filter_by_search_query(search_query)
    filter_by_assessment(assessment_id)
    sorted
    @relation.distinct
  end
end
