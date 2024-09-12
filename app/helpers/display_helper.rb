module DisplayHelper
  def display_percentage_or_minus(value)
    if value.nil?
      svg_tag "minus"
    else
      tag.p "#{value}%"
    end
  end

  def display_duration_or_minus(duration_seconds)
    if duration_seconds.zero?
      svg_tag "minus", class: "size-5 mt-0.5"
    else
      tag.p format_duration(duration_seconds)
    end
  end
end
