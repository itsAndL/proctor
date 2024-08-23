module NavbarVisibilityConcern
  extend ActiveSupport::Concern

  def hide_navbar
    @hide_navbar = true
  end
end
