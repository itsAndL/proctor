module AssessmentItemManagement
  extend ActiveSupport::Concern

  included do
    before_action :set_assessment
    before_action :set_item
    before_action :set_assessment_item, only: %i[change_position destroy]
  end

  def create
    @assessment.send(association_name).create(item_key => @item)
    respond_with_turbo_stream
  end

  def change_position
    movement = { 'up' => :move_higher, 'down' => :move_lower }
    @assessment_item.send(movement[params[:direction]]) if movement.key?(params[:direction])

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(table_id, render_table) }
    end
  end

  def destroy
    @assessment_item.destroy
    respond_with_turbo_stream
  end

  private

  def set_assessment
    @assessment = Assessment.find(params[:assessment_hashid])
  end

  def set_item
    @item = item_class.find(params[item_param_key])
  end

  def set_assessment_item
    @assessment_item = @assessment.send(association_name).find_by!(item_key => @item)
  end

  def respond_with_turbo_stream
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream_updates }
    end
  end

  def turbo_stream_updates
    [
      turbo_stream.replace(table_id, render_table),
      turbo_stream.replace("#{item_name}_#{@item&.hashid}", render_item_card),
      turbo_stream.replace('assessment_header', render_header)
    ]
  end

  def render_header
    AssessmentHeaderComponent.new(assessment: @assessment)
  end

  def string_to_boolean(string)
    ActiveModel::Type::Boolean.new.cast(string)
  end

  # These methods should be implemented in the subclasses
  def association_name; end
  def item_class; end
  def item_param_key; end
  def item_key; end
  def item_name; end
  def table_id; end
  def render_table; end
  def render_item_card; end
end
