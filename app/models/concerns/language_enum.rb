module LanguageEnum
  extend ActiveSupport::Concern

  included do
    enum language: {
      english: 0,
      spanish: 1,
      french: 2,
      german: 3
    }
  end
end
