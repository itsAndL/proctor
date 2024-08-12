class Option < ApplicationRecord
  belongs_to :optionable, polymorphic: true
  has_rich_text :content

  validates :content, presence: true
end
