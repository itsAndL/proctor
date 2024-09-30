class ProfileController < ApplicationController
  before_action :authenticate_user!

  def change_locale
    changed_locale = params[:locale].to_sym
    return unless I18n.available_locales.include?(changed_locale)

    current_user.update(locale: changed_locale) if user_signed_in?
    redirect_to url_for(locale: changed_locale)
  end
end
