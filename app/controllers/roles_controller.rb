class RolesController < ApplicationController
  before_action :authenticate_user!
end
