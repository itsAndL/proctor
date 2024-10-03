class Candidate::SessionsController < Devise::SessionsController
  include CustomRedirect

  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

  protected

  def after_sign_in_path_for(_resource)
    redirect_to_appropriate_path
  end
end
