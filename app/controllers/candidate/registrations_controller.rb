class Candidate::RegistrationsController < Devise::RegistrationsController
  include CustomRedirect

  def new
    build_resource
    resource.build_candidate
    respond_with resource
  end

  def create
    build_resource(sign_up_params)
    resource.skip_confirmation!
    resource.skip_confirmation_notification!

    if resource.save
      set_flash_message! :notice, :signed_up
      sign_up(resource_name, resource)
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def sign_up_params
    params.require(:user).permit(:email, :password, candidate_attributes: [:name])
  end

  def after_sign_up_path_for(_resource)
    redirect_to_appropriate_path
  end
end
