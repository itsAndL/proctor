class BusinessesController < ApplicationController
  def new
    @business = current_user.build_business
  end

  def create
    @business = current_user.build_business
    @business.assign_attributes(business_params)

    if @business.save
      redirect_to edit_business_path(@business), notice: 'Business was successfully created.'
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
      redirect_to customer_assessments_path, notice: 'Business was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def business_params
    params.require(:business).permit(:contact_name, :contact_role, :company, :bio, :website, :avatar)
  end
end
