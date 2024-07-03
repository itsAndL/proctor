module ApplicationHelper
  def svg_tag(icon_name, options = {})
    file = Rails.root.join('app/assets/images/svg', "#{icon_name}.svg").read
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'

    options.each { |attr, value| svg[attr.to_s] = value }

    doc.to_html.html_safe
  end

  def navbar_tab_style(active_tab)
    if controller_name == active_tab
      'whitespace-nowrap inline-flex items-center border-b-4 border-blue-500 px-1 pt-1 text-sm font-medium text-gray-900'
    else
      'whitespace-nowrap inline-flex items-center border-b-4 border-transparent px-1 pt-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700'
    end
  end
end
