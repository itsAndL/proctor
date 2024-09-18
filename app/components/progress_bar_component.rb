# frozen_string_literal: true

class ProgressBarComponent < ViewComponent::Base
  def initialize(progress: 0, total: 0, classes: nil, progress_classes: '', total_classes: '', data: {})
    super
    @progress = progress
    @total = total
    @classes = classes || 'mt-1 col-span-9 w-full bg-gray-200 rounded-full h-2.5'
    @progress_classes = progress_classes
    @total_classes = total_classes
    @data = data
  end

  def percent
    return 0 if @total.zero?

    (@progress.to_f / @total) * 100
  end
end
