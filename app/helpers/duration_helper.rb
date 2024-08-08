module DurationHelper
  def format_duration(secs)
    mins = secs / 60
    hours = mins / 60

    if hours >= 1
      "#{hours} #{hours == 1 ? 'hour' : 'hours'}"
    elsif mins >= 1
      "#{mins} #{mins == 1 ? 'min' : 'mins'}"
    else
      "#{secs} #{secs == 1 ? 'sec' : 'secs'}"
    end
  end
end
