# frozen_string_literal: true

class InviteModalComponent < ViewComponent::Base
  def initialize(assessment:, active_tab:)
    @assessment = assessment
    @active_tab = active_tab
  end

  private

  def tab_class(tab)
    if tab == @active_tab
      'bg-blue-50 whitespace-nowrap border-b-2 border-blue-500 px-4 py-4 text-sm font-bold text-gray-900'
    else
      'whitespace-nowrap border-b border-transparent px-4 py-4 text-sm font-medium text-gray-900 hover:border-gray-300 hover:bg-gray-50'
    end
  end
end
