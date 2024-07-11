# frozen_string_literal: true

class NavBar::GuestComponent < ViewComponent::Base
  def render?
    show_navbar?
  end

  private

  def show_navbar?
    !helpers.devise_controller?
  end
end
