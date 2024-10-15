module LanguageHelper
  def map_locale_to_language(locale)
    languages = { en: :english, fr: :french }
    languages[locale.to_sym]
  end
end
