module Locales
  extend ActiveSupport::Concern

  private

  included do
    def set_locale(&action)
      locale = if user_signed_in?
                 current_user.locale.to_sym
               elsif params[:locale].present? && I18n.available_locales.map(&:to_s).include?(params[:locale])
                 params[:locale].to_sym
               else
                 I18n.default_locale
               end
      I18n.with_locale(locale, &action)
    end

    def default_url_options(options = {})
      options.merge({ locale: resolve_locale })
    end

    def resolve_locale(locale = I18n.locale)
      locale == I18n.default_locale ? nil : locale
    end
  end
end
