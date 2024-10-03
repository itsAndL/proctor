class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_one :business, dependent: :destroy
  has_one :candidate, dependent: :destroy

  accepts_nested_attributes_for :business
  accepts_nested_attributes_for :candidate

  # Skip confirmation for candidates
  def skip_confirmation!
    self.confirmed_at = Time.current if candidate?
  end

  # Automatically confirm email for candidates
  def after_confirmation
    self.confirm! if candidate?
  end

  def business?
    business.present?
  end

  def candidate?
    candidate.present?
  end
end
