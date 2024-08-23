# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include AuthenticationConcern
  include SecondaryRootPath
  include PaginationConcern
  include NavbarVisibilityConcern

  protected

  def after_sign_up_path_for(resource)
    new_role_path
  end

  def after_sign_in_path_for(resource)
    secondary_root_path
  end
end
