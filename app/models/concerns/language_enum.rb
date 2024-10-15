module LanguageEnum
  extend ActiveSupport::Concern

  included do
    enum language: { english: 0, french: 2 }
  end
end
