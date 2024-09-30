class ApplicationController < ActionController::Base
  include AuthenticationConcern
  include Locales
  include SecondaryRootPath
  include PaginationConcern
  include NavbarVisibilityConcern

  around_action :set_locale

  protected

  def after_sign_up_path_for(_resource)
    new_role_path
  end

  def after_sign_in_path_for(_resource)
    secondary_root_path
  end
end
