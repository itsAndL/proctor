class CustomQuestionLibraryController < ApplicationController
  def index
    # Initialize @custom_questions with all custom questions by default
    @custom_questions = CustomQuestion.all

    # Filter by search query if present
    if params[:search_query].present?
      @custom_questions = @custom_questions.filter_by_search_query(params[:search_query])
    end

    # Filter by selected question categories if any
    if params[:question_category].present?
      question_category_ids = params[:question_category].map(&:to_i)
      @custom_questions = @custom_questions.where(custom_question_category_id: question_category_ids)
    end

    # Filter by selected question types if any
    if params[:question_type].present?
      question_types = params[:question_type].map(&:camelize)
      @custom_questions = @custom_questions.where(type: question_types)
    end

    @custom_questions = @custom_questions.order(:position)
  end
end
