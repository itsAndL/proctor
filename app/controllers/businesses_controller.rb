class BusinessesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :authenticate_business!, only: %i[edit update]
  before_action :require_new_business!, only: %i[new create]

  def new
    @business = current_user.build_business
  end

  def create
    @business = current_user.build_business
    @business.assign_attributes(business_params)

    if @business.save
      redirect_to edit_business_path(@business), notice: t('flash.personalize_successfully_created', resource: Business.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @business = current_business
  end

  def update
    @business = current_business

    if @business.update(business_params)
      redirect_to secondary_root_path, notice: t('flash.personalize_successfully_updated', resource: Business.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def require_new_business!
    return if current_business.blank?

    redirect_to edit_business_path(current_business)
  end

  def business_params
    params.require(:business).permit(:contact_name, :contact_role, :company, :bio, :website, :avatar, user_attributes: %i[id locale])
  end

  def new_locale
    params.dig('business', 'user', 'locale')
  end
end
