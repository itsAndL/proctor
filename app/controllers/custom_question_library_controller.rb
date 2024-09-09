class CustomQuestionLibraryController < ApplicationController
  before_action :authenticate_business!

  def index
    query = CustomQuestionQuery.new

    @custom_questions = query.execute(
      search_query: params[:search_query],
      category_ids: params[:question_category]&.map(&:to_i),
      types: params[:question_type],
      business: current_business,
      only_system: params[:question_source]&.include?('assesskit'),
      only_business: params[:question_source]&.include?('my_company')
    )
  end
end
