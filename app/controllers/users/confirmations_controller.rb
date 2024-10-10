class Users::ConfirmationsController < Devise::ConfirmationsController
  include SecondaryRootPath

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message!(:notice, :confirmed)
      sign_in(resource)
      respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
    end
  end

  protected

  def after_confirmation_path_for(_resource_name, _resource)
    secondary_root_path
  end

  def after_resending_confirmation_instructions_path_for(_resource_name)
    secondary_root_path
  end
end
