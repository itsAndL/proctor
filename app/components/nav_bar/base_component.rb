# frozen_string_literal: true

class NavBar::BaseComponent < ViewComponent::Base
  def initialize(current_path:, user:, hide_navbar: false)
    @current_path = current_path
    @user = user
    @hide_navbar = hide_navbar
  end

  def call
    render component
  end

  def render?
    return false if @hide_navbar
    return false if helpers.devise_controller? && !on_edit_user_registration_page?

    true
  end

  def component
    if helpers.guest_page?(@current_path) || @user.blank?
      NavBar::GuestComponent.new
    else
      NavBar::UserComponent.new(@user)
    end
  end

  private

  def on_edit_user_registration_page?
    helpers.normalize_path(request.path) == helpers.normalize_path(edit_user_registration_path)
  end
end
