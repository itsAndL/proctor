class BusinessesController < ApplicationController
  before_action :require_new_business!, only: %i[new create]

  def new
    @business = current_user.build_business
  end

  def create
    @business = current_user.build_business
    @business.assign_attributes(business_params)

    if @business.save
      redirect_to edit_business_path(@business.hashid), notice: 'Your business profile was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @business = current_user.business
  end

  def update
    @business = current_user.business

    if @business.update(business_params)
      redirect_to customer_assessments_path, notice: 'Your business profile was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def require_new_business!
    return if current_user.business.blank?

    redirect_to edit_business_path(current_user.business)
  end

  def business_params
    params.require(:business).permit(:contact_name, :contact_role, :company, :bio, :website, :avatar)
  end
end
