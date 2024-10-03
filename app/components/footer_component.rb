# frozen_string_literal: true

class FooterComponent < ViewComponent::Base
  def initialize(request:)
    @request = request
  end

  def render?
    guest_paths.include?(remove_locale_from_path(@request.path))
  end

  private

  def remove_locale_from_path(path)
    locales = I18n.available_locales.join('|')
    path.sub(%r{^/(#{locales})(/|$)}, '/')
  end

  def guest_paths
    [root_path, home_path, contact_path, about_path].map { |path| remove_locale_from_path(path) }
  end
end
