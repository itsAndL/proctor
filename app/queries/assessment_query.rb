class AssessmentQuery
  attr_reader :relation

  def initialize(relation = Assessment.all)
    @relation = relation
  end

  def filter_by_search_query(search_query)
    return relation if search_query.blank?

    @relation = relation.filter_by_search_query(search_query)
  end

  def filter_by_state(state = 'active')
    return relation unless %w[active archived].include?(state)

    @relation = relation.public_send(state)
  end

  def sorted
    @relation = relation.order(created_at: :desc)
  end

  def execute(search_query: nil, state: 'active')
    filter_by_search_query(search_query)
    filter_by_state(state)
    sorted
    @relation
  end
end
