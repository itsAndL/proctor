module DurationHelper
  def format_duration(secs, long_format = false)
    hours, remaining = secs.divmod(3600)
    mins, secs = remaining.divmod(60)

    if hours > 0
      pluralize(hours, 'hour')
    elsif mins > 0
      format_unit(mins, 'minute', 'min', long_format)
    elsif secs > 0
      format_unit(secs, 'second', 'sec', long_format)
    else
      format_unit(0, 'minute', 'min', long_format)
    end
  end

  private

  def format_unit(value, long_name, short_name, long_format)
    unit = long_format ? long_name : short_name
    pluralize(value, unit)
  end

  def pluralize(count, unit)
    "#{count} #{unit.pluralize(count)}"
  end
end
