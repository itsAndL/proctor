class AddIndexToTestsFormat < ActiveRecord::Migration[7.1]
  def change
    add_index :tests, :format
  end
end
