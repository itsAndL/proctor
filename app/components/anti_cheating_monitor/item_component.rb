# frozen_string_literal: true

class AntiCheatingMonitor::ItemComponent < ViewComponent::Base
  def initialize(icon:, label:, value:)
    @icon = icon
    @label = label
    @value, @status = parse_value(value)
  end

  private

  attr_reader :icon, :label, :value, :status

  def parse_value(value)
    case value
    when Array
      value
    when String
      [value, :neutral]
    else
      ['N/A', :neutral]
    end
  end

  def status_class
    case status
    when :positive
      'bg-lime-200'
    when :negative
      'bg-red-300'
    else
      ''
    end
  end

  def value_class
    if status == :neutral
      'text-gray-800 text-sm font-medium'
    else
      "h-fit text-gray-800 font-medium text-xs rounded-full px-2 py-0.5 #{status_class}"
    end
  end
end
