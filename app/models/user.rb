class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_one :business, dependent: :destroy
  has_one :candidate, dependent: :destroy

  enum locale: {
    en: 0,
    es: 1,
    fr: 2,
    de: 3
  }

  def business?
    business.present?
  end

  def candidate?
    candidate.present?
  end
end
