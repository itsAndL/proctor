class Customer::CandidatesController < ApplicationController
  before_action :authenticate_business!

  def index
    query = CandidateQuery.new(current_business.candidates_for_search)
    @candidates = query.execute(
      search_query: params[:search_query],
      assessment_id: params[:assessment_id]
    )
    @candidates = paginate(query.relation)
  end

  def show
    @candidate = Candidate.find(params[:hashid])
  end
end
