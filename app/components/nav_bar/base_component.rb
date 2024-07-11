# frozen_string_literal: true

class NavBar::BaseComponent < ViewComponent::Base
  def initialize(request:, user:)
    @request = request
    @user = user
  end

  def component
    if @user.blank? || active_guest_path
      NavBar::GuestComponent.new
    else
      NavBar::UserComponent.new(@user)
    end
  end

  private

  def active_guest_path
    guest_paths.include?(@request.path)
  end

  def guest_paths
    [root_path, home_path, contact_path, about_path]
  end
end
