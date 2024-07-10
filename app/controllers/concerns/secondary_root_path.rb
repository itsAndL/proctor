module SecondaryRootPath
  extend ActiveSupport::Concern

  def secondary_root_path
    return root_path unless helpers.current_user

    if helpers.current_user.business&.persisted?
      customer_assessments_path
    elsif helpers.current_user.candidate&.persisted?
      candidate_assessments_path
    else
      new_role_path
    end
  end
end
