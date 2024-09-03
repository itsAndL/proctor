module AssessmentParticipationsHelper
  def status_style(status)
    case status
    when 'completed'
      'text-lime-900 bg-lime-200'
    else
      'text-blue-900 bg-blue-200'
    end
  end
end
