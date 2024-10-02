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
    if guest_page? || @user.blank?
      NavBar::GuestComponent.new
    else
      NavBar::UserComponent.new(@user)
    end
  end

  private

  def guest_page?
    [root_path, home_path, contact_path, about_path].include?(@current_path)
  end

  def on_edit_user_registration_page?
    helpers.current_page?(helpers.edit_user_registration_path)
  end
end
