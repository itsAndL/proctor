class Assessment < ApplicationRecord
  include Hashid::Rails

  belongs_to :business

  validates :title, :language, presence: true

  enum language: { en: 0, fr: 1 }
end
