# frozen_string_literal: true

class LabelExplainerComponent < ViewComponent::Base
  def initialize(form:, name:, message:, **options)
    @form = form
    @name = name
    @message = message
    @options = options
  end
end
