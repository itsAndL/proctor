class AssessmentsController < ApplicationController
  before_action :set_assessment, except: %i[index new create]

  def index
    @assessments = current_user.business.assessments

    # Filter by search query if present
    if params[:search_query].present?
      @assessments = @filtered_assessments = @assessments.filter_by_search_query(params[:search_query])
    end

    @filtered_assessments ||= @assessments

    # Filter by state
    @state = params[:state] || 'active'
    @assessments = @assessments.public_send(@state) if %w[active archived].include?(@state)

    @assessments = @assessments.order(created_at: :desc)

    # Apply pagination
    @assessments = paginate(@assessments)
  end

  def new
    @assessment = Assessment.new
  end

  def create
    @assessment = Assessment.new(assessment_params.merge(business_id: current_user.business.id))

    if @assessment.save
      redirect_to(
        choose_tests_assessment_path(@assessment),
        notice: 'The assessment was successfully created.'
      )
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @assessment.update(assessment_params)
      redirect_to(
        determine_redirect_path(choose_tests_assessment_path(@assessment)),
        notice: 'The assessment was successfully updated.'
      )
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def archive
    @assessment.archive!
    redirect_to assessments_path, notice: 'Assessment was successfully archived.'
  end

  def unarchive
    @assessment.unarchive!
    redirect_to assessments_path, notice: 'Assessment was successfully unarchived.'
  end

  def choose_tests; end

  def update_tests
    if @assessment.update(test_params)
      update_assessment_test_positions
      redirect_to(
        determine_redirect_path(add_questions_assessment_path(@assessment)),
        notice: "The assessment's tests were successfully updated."
      )
    else
      render :choose_tests, status: :unprocessable_entity
    end
  end

  def add_questions; end

  def update_questions
    redirect_to(
      determine_redirect_path(finalize_assessment_path(@assessment)),
      notice: "The assessment's questions were successfully updated."
    )
  end

  def finalize; end

  def finish
    redirect_to '/customer/assessments/1', notice: 'Assessment was successfully finalized.'
  end

  private

  def set_assessment
    @assessment = Assessment.find(params[:hashid])
  end

  def assessment_params
    params.require(:assessment).permit(:title, :language)
  end

  def test_params
    params.require(:assessment).permit(test_ids: [])
  end

  def update_assessment_test_positions
    params[:assessment][:test_ids].each_with_index do |test_id, index|
      @assessment.assessment_tests.find_by(test_id:)&.update(position: index + 1)
    end
  end

  def determine_redirect_path(continue_path)
    return continue_path unless params[:save_and_exit] == 'true'

    '/customer/assessments/1'
  end
end
