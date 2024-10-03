module PagesHelper
  def guest_page?(path)
    normalized_path = normalize_path(path)
    guest_paths.include?(normalized_path)
  end

  def normalize_path(path)
    normalized = path.gsub(%r{^/(?:#{I18n.available_locales.join('|')})}, '')
    normalized.empty? ? '/' : normalized
  end

  private

  def guest_paths
    [root_path, home_path, contact_path, about_path].map { |p| normalize_path(p) }
  end
end
