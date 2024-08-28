module AssessmentFinder
  extend ActiveSupport::Concern

  included do
    private

    def set_assessment
      @assessment = Assessment.find(params[:hashid])
    end

    def find_assessment_by_public_link
      Assessment.find_by!(public_link_token: params[:public_link_token])
    end
  end
end
