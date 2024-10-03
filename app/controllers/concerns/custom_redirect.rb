module CustomRedirect
  extend ActiveSupport::Concern

  included do
    include SecondaryRootPath
  end

  def redirect_to_appropriate_path
    path = stored_location_for(:user)
    path && !guest_page?(path) ? path : secondary_root_path
  end

  private

  def guest_page?(path)
    [root_path, home_path, contact_path, about_path].include? normalize_path(path)
  end

  def normalize_path(path)
    path.gsub(%r{^/(?:#{I18n.available_locales.join('|')})}, '')
  end
end
