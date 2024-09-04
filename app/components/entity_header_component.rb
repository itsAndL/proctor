# frozen_string_literal: true

class EntityHeaderComponent < ViewComponent::Base
  def initialize(entity:, back_path:, show_navigation: false, prev_path: nil, next_path: nil, current_index: nil, total_count: nil)
    @entity = entity
    @back_path = back_path
    @show_navigation = show_navigation
    @prev_path = prev_path
    @next_path = next_path
    @current_index = current_index
    @total_count = total_count
  end

  def entity_name
    @entity.respond_to?(:name) ? @entity.name : @entity.participant.name
  end

  def entity_email
    @entity.respond_to?(:email) ? @entity.email : @entity.participant.email
  end

  def avatarable
    @entity.respond_to?(:avatar) ? @entity : @entity.participant
  end
end
