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

  enum locale: {
    en: 0,
    fr: 1,
    es: 2,
    de: 3
  }

  def business?
    business.present?
  end

  def candidate?
    candidate.present?
  end

  def skip_confirmation!
    super
    self.confirmed_at = Time.current if candidate?
  end

  def send_confirmation_notification?
    super && !candidate?
  end

  def will_save_change_to_email?
    super || (email.present? && email_in_database.present? && email != email_in_database)
  end
end
