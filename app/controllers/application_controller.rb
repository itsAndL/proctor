class ApplicationController < ActionController::Base
  include AuthenticationConcern
  include SecondaryRootPath
  include PaginationConcern
  include NavbarVisibilityConcern

  before_action :switch_locale

  def switch_locale
    locale = params[:locale] || I18n.default_locale
    I18n.locale = locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  protected

  def after_sign_up_path_for(_resource)
    new_role_path
  end

  def after_sign_in_path_for(_resource)
    secondary_root_path
  end
end
