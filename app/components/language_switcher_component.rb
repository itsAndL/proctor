# frozen_string_literal: true

class LanguageSwitcherComponent < ViewComponent::Base
  def initialize(guest: true)
    super
    @guest = guest
    @locales = I18n.available_locales
  end
end
