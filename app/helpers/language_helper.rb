module LanguageHelper
  def map_locale_to_language(locale)
    languages = {
      en: :english,
      fr: :french,
      de: :german,
      es: :spanish
    }
    languages[locale.to_sym]
  end
end
