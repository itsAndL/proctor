class ApplicationController < ActionController::Base

  protected

  def after_sign_up_path_for(resource)
    new_role_path # Change this to the path you want to redirect to
  end

  def after_sign_in_path_for(resource)
    new_role_path # Change this to the path you want to redirect to
  end
end
