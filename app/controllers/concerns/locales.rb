module Locales
  extend ActiveSupport::Concern

  private

  included do
    def set_locale(&action)
      accept_language = request.env['HTTP_ACCEPT_LANGUAGE']&.first(2)
      locale =
        if params[:locale].present? && valide_locale?(params[:locale])
          params[:locale].to_sym
        elsif user_signed_in?
          current_user.locale.to_sym
        elsif accept_language.present? && valide_locale?(accept_language)
          accept_language.to_sym
        else
          I18n.default_locale
        end

      current_user.update(locale:) if user_signed_in? && current_user.locale.to_sym != locale
      if params[:locale] != locale.to_s && request.get?
        redirect_to url_for(params.permit!.merge(locale:))
      else
        I18n.with_locale(locale, &action)
      end
    end

    def default_url_options(options = {})
      options.merge({ locale: resolve_locale })
    end

    def resolve_locale(locale = I18n.locale)
      locale == I18n.default_locale ? nil : locale
    end

    def valide_locale?(locale)
      I18n.available_locales.map(&:to_s).include?(locale)
    end
  end
end
