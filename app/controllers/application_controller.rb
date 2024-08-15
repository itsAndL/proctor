class ApplicationController < ActionController::Base
  include SecondaryRootPath

  protected

  def after_sign_up_path_for(resource)
    new_role_path
  end

  def after_sign_in_path_for(resource)
    secondary_root_path
  end

  def paginate(records)
    @per_page = (params[:per_page] || 25).to_i
    @current_page = (params[:page] || 1).to_i
    @total_items = records.count
    @total_pages = (@total_items.to_f / @per_page).ceil

    records.offset((@current_page - 1) * @per_page).limit(@per_page)
  end
end
