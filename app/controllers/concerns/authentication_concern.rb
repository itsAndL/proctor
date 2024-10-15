module AuthenticationConcern
  include SecondaryRootPath
  extend ActiveSupport::Concern

  included do
    helper_method :current_business, :current_candidate
    before_action :store_user_location!, if: :storable_location?
  end

  private

  def authenticate_business!
    unless current_user
      store_location_for(:user, request.fullpath)
      redirect_to new_user_session_path, alert: t('alert.business_required')
      return
    end

    return if current_business

    redirect_to secondary_root_path, alert: t('alert.log_as_business')
  end

  def authenticate_candidate!
    unless current_user
      store_location_for(:user, request.fullpath)

      invitation_service = InvitationAuthenticationService.new(self)
      return if invitation_service.authenticate

      redirect_to new_user_session_path, alert: t('alert.candidate_required')
      return
    end

    return if current_candidate

    redirect_to secondary_root_path, alert: t('alert.log_as_candidate')
  end

  def current_business
    @current_business ||= current_user&.business
  end

  def current_candidate
    @current_candidate ||= current_user&.candidate
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end
