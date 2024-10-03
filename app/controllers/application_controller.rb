class ApplicationController < ActionController::Base
  include AuthenticationConcern
  include PaginationConcern
  include NavbarVisibilityConcern
end
