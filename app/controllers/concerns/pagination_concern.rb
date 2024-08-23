module PaginationConcern
  extend ActiveSupport::Concern

  def paginate(records)
    @per_page = (params[:per_page] || 10).to_i
    @current_page = (params[:page] || 1).to_i
    @total_items = records.count

    records.offset((@current_page - 1) * @per_page).limit(@per_page)
  end
end
