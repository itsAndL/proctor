class Users::PasswordsController < Devise::PasswordsController
  include CustomRedirect

  protected

  def after_resetting_password_path_for(_resource)
    redirect_to_appropriate_path
  end
end
