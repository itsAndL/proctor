module ApplicationHelper
  def svg_tag(icon_name, options = {})
    file = Rails.root.join('app/assets/images/icons', "#{icon_name}.svg").read
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'

    options.each { |attr, value| svg[attr.to_s] = value }

    doc.to_html.html_safe
  end

  def assesskit_url
    "https://www.assesskit.com"
  end

  def human_date(date)
    date.strftime("%B %d, %Y")
  end

  def status_style(status)
    case status
    when 'active'
      'text-lime-900 bg-lime-200'
    else
      'text-blue-900 bg-blue-200'
    end
  end
end
