class AssessmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_assessment, except: %i[index new create]
  before_action :authorize_record, except: %i[index new create]

  def index
    authorize!
    query = AssessmentQuery.new(current_user)
    @filtered_assessments = query.filter_by_search_query(params[:search_query])

    @state = params[:state] || 'active'
    query.filter_by_state(@state)

    query.sorted
    @assessments = paginate(query.relation)
  end

  def show
    query = AssessmentParticipationQuery.new(user: current_user, relation: @assessment.assessment_participations)
    @assessment_participations = query.execute(search_query: params[:search_query], status: params[:status])
    @assessment_participations = paginate(query.relation)
  end

  def new
    @assessment = Assessment.new
  end

  def create
    @assessment = Assessment.new(assessment_params.merge(business_id: current_business.id))

    if @assessment.save
      redirect_to(
        choose_tests_assessment_path(@assessment),
        notice: t('flash.create_success')
      )
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @assessment.update(assessment_params)
      redirect_to(
        determine_redirect_path(choose_tests_assessment_path(@assessment)),
        notice: t('flash.update_success')
      )
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def archive
    @assessment.archive!
    redirect_to assessments_path, notice: t('flash.archive_success')
  end

  def unarchive
    @assessment.unarchive!
    redirect_to assessments_path, notice: t('flash.unarchive_success')
  end

  def require_edit; end

  def choose_tests; end

  def update_tests
    if @assessment.update(test_params)
      update_assessment_test_positions
      redirect_to(
        determine_redirect_path(add_questions_assessment_path(@assessment)),
        notice: t('flash.update_tests_success')
      )
    else
      render :choose_tests, status: :unprocessable_entity
    end
  end

  def add_questions; end

  def update_questions
    redirect_to(
      determine_redirect_path(finalize_assessment_path(@assessment)),
      notice: t('flash.update_questions_success')
    )
  end

  def finalize; end

  def finish
    redirect_to assessment_path(@assessment), notice: t('flash.finish_success')
  end

  def rename; end

  def update_title
    if @assessment.update(title: params[:assessment][:title])
      respond_to do |format|
        format.turbo_stream do
          render(turbo_stream:
            [
              turbo_stream.replace(
                'assessment-title', AssessmentTitleComponent.new(assessment: @assessment, rename: true)
              ),
              turbo_stream.replace('modal', helpers.turbo_frame_tag('modal')),
              turbo_stream.replace('notification', NotificationComponent.new(notice: t('flash.update_title_success')))
            ])
        end
      end
    else
      render :rename, status: :unprocessable_entity
    end
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

    assessment_path(@assessment)
  end

  def authorize_record
    authorize! @assessment
  end
end
