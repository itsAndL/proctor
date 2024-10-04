class Users::SessionsController < Devise::SessionsController
  include CustomRedirect

  protected

  def after_sign_in_path_for(_resource)
    redirect_to_appropriate_path
  end
end
