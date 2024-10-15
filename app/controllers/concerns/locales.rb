module Locales
  extend ActiveSupport::Concern

  included do
    around_action :set_locale
  end

  private

  def set_locale(&)
    locale = extract_locale_from_params || extract_locale_from_user ||
             extract_locale_from_header || I18n.default_locale

    locale = locale.to_sym
    locale = I18n.default_locale unless valid_locale?(locale)

    update_user_locale(locale) if user_signed_in?

    I18n.with_locale(locale, &)
  end

  def extract_locale_from_params
    params[:locale] if params[:locale].present?
  end

  def extract_locale_from_user
    current_user.locale.to_sym if user_signed_in?
  end

  def extract_locale_from_header
    accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
    return nil unless accept_language

    preferred_language = accept_language.scan(/^[a-z]{2}/).first
    preferred_language&.to_sym
  end

  def valid_locale?(locale)
    I18n.available_locales.include?(locale)
  end

  def update_user_locale(locale)
    current_user.update(locale: locale.to_s) if current_user.locale.to_sym != locale
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
