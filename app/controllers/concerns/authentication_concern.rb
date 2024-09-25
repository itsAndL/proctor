module AuthenticationConcern
  extend ActiveSupport::Concern

  included do
    helper_method :current_business, :current_candidate
  end

  private

  def authenticate_business!
    authenticate_user!
    return if current_user.business

    redirect_to root_path, alert: t('alert.business_required')
  end

  def authenticate_candidate!
    authenticate_user!
    return if current_user.candidate

    redirect_to root_path, alert: t('alert.candidate_required')
  end

  def current_business
    @current_business ||= current_user&.business
  end

  def current_candidate
    @current_candidate ||= current_user&.candidate
  end
end
