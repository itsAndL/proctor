class Users::RegistrationsController < Devise::RegistrationsController
  include SecondaryRootPath

  protected

  def after_update_path_for(_resource)
    secondary_root_path
  end
end
