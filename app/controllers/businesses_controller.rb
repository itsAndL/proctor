class BusinessesController < ApplicationController
  include SecondaryRootPath

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
      redirect_to edit_business_path(@business), notice: 'Your business profile was successfully created.'
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
      redirect_to secondary_root_path, notice: 'Your business profile was successfully updated.'
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
    params.require(:business).permit(:contact_name, :contact_role, :company, :bio, :website, :avatar)
  end
end
