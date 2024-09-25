class ApplicationPolicy < ActionPolicy::Base
  private

  def business_owner?
    user.business? && user.business.id == record.business_id
  end
end
