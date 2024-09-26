class Customer::CandidatesController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize!
    query = CandidateQuery.new(user: current_user)
    @candidates = query.execute(
      search_query: params[:search_query],
      assessment_id: params[:assessment_id]
    )
    @candidates = paginate(query.relation)
  end

  def show
    @candidate = current_business.candidates.find(params[:hashid])
    authorize! @candidate
  end
end
