module Questionable
  extend ActiveSupport::Concern

  included do
    include Hashid::Rails

    has_rich_text :content
    has_many :options, as: :optionable, dependent: :destroy, autosave: true

    validates :content, :type, presence: true
  end
end
