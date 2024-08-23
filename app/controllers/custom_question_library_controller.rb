class CustomQuestionLibraryController < ApplicationController
  before_action :authenticate_business!

  def index
    query = CustomQuestionQuery.new

    @custom_questions = query.execute(
      search_query: params[:search_query],
      category_ids: params[:question_category]&.map(&:to_i),
      types: params[:question_type]
    )
  end
end
