module DurationHelper
  def format_duration(secs, long_format = false)
    return t('duration.zero_min') if secs.nil?

    hours, remaining = secs.divmod(3600)
    mins, secs = remaining.divmod(60)
    secs = secs.round(2)  # Round seconds to 2 decimal places

    if hours > 0
      pluralize(hours, t('duration.hour'))
    elsif mins > 0
      format_unit(mins, t('duration.minute'), t('duration.min'), long_format)
    elsif secs > 0
      format_unit(secs, t('duration.second'), t('duration.sec'), long_format)
    else
      format_unit(0, t('duration.minute'), t('duration.min'), long_format)
    end
  end

  def format_duration_hms(seconds)
    return "00:00:00" if seconds.nil?

    hours, remaining = seconds.divmod(3600)
    minutes, seconds = remaining.divmod(60)
    format("%02d:%02d:%02d", hours, minutes, seconds)
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