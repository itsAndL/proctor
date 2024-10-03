module LanguageEnum
  extend ActiveSupport::Concern

  included do
    enum language: {
      english: 0,
      spanish: 1,
      french: 2,
      german: 3
    }

    def self.language_name_by_locale(locale)
      languages = {
        en: :english,
        fr: :french,
        de: :german,
        es: :spanish
      }
      languages[locale.to_sym].to_s
    end
  end
end
