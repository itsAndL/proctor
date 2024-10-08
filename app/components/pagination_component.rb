# frozen_string_literal: true

class PaginationComponent < ViewComponent::Base
  attr_reader :current_page, :total_items, :per_page, :additional_params, :per_page_options

  def initialize(current_page:, total_items:, per_page:, additional_params: {}, per_page_options: [10, 25, 50], article_name: nil)
    @current_page = [current_page.to_i, 1].max
    @total_items = [total_items.to_i, 0].max
    @per_page = per_page.to_i
    @additional_params = additional_params
    @per_page_options = per_page_options
    @article_name = article_name
  end

  def total_pages
    pages = (@total_items / @per_page.to_f).ceil
    [pages, 1].max # Ensure at least one page is displayed
  end

  def previous_page
    current_page > 1 ? current_page - 1 : nil
  end

  def next_page
    current_page < total_pages ? current_page + 1 : nil
  end

  def page_path(page:)
    url_for(additional_params.merge(page:, per_page:))
  end

  def start_item
    return 0 if total_items.zero?

    ((current_page - 1) * per_page) + 1
  end

  def end_item
    [current_page * per_page, total_items].min
  end

  def page_info
    "#{start_item} - #{end_item} #{t('of')} #{total_items}"
  end
end
