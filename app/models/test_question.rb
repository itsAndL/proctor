class TestQuestion < ApplicationRecord
  belongs_to :test
  belongs_to :question

  acts_as_list scope: :test
end
