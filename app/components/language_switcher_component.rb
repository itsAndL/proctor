# frozen_string_literal: true

class LanguageSwitcherComponent < ViewComponent::Base
  def initialize
    super
    @locales = I18n.available_locales
  end
end
