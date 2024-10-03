# frozen_string_literal: true

class FooterComponent < ViewComponent::Base
  include PagesHelper

  def initialize(request:)
    @request = request
  end

  def render?
    helpers.guest_page?(@request.path)
  end
end
