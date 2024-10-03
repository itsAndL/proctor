class ApplicationController < ActionController::Base
  include AuthenticationConcern
  include PaginationConcern
  include NavbarVisibilityConcern
  include Locales

  around_action :set_locale
end
