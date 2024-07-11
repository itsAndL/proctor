# frozen_string_literal: true

class FooterComponent < ViewComponent::Base
  def initialize(request:)
    @request = request
  end

  def render?
    guest_paths.include?(@request.path)
  end

  private

  def guest_paths
    [root_path, home_path, contact_path, about_path]
  end
end
