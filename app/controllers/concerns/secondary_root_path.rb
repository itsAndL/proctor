module SecondaryRootPath
  extend ActiveSupport::Concern

  def secondary_root_path
    return root_path unless helpers.current_user

    if helpers.current_business&.persisted?
      assessments_path
    elsif helpers.current_candidate&.persisted?
      candidate_assessment_participations_path
    else
      new_role_path
    end
  end
end
