module LanguageEnum
  extend ActiveSupport::Concern

  included do
    enum language: { en: 0, fr: 1 }
  end
end
