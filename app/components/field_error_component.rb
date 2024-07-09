# frozen_string_literal: true

class FieldErrorComponent < ViewComponent::Base
  def initialize(attribute, resource)
    @attribute = attribute
    @resource = resource
  end

  def errors
    @resource.errors[@attribute]
  end

  def any_error?
    errors.any?
  end
end
