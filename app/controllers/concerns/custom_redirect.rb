module CustomRedirect
  extend ActiveSupport::Concern

  included do
    include SecondaryRootPath
    include PagesHelper
  end

  def redirect_to_appropriate_path
    path = stored_location_for(:user)
    path && !helpers.guest_page?(path) ? path : secondary_root_path
  end
end
