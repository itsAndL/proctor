module CustomPathsHelper
  def profile_path
    if current_user.candidate?
      edit_candidate_path(current_user.candidate)
    elsif current_user.business?
      edit_business_path(current_user.business)
    end
  end
end
