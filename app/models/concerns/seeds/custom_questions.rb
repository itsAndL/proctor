module Seeds
  module CustomQuestions
    def create_custom_question!(title, attributes = {})
      ActiveRecord::Base.transaction do
        CustomQuestion.find_or_create_by!(title:, type: attributes['type']) do |custom_question|
          custom_question.attributes = attributes
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Failed to create CustomQuestion: #{e.message}")
      raise
    end
  end
end
