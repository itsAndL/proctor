class InviteCandidatesController < ApplicationController
  before_action :set_assessment

  def share; end

  def invite; end

  def bulk_invite; end

  private

  def set_assessment
    @assessment = Assessment.find(params[:hashid])
  end
end
