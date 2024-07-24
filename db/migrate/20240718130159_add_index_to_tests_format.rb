class AddIndexToTestsFormat < ActiveRecord::Migration[7.1]
  def up
    add_index :tests, :format unless index_exists?(:tests, :format)
  end

  def down
    remove_index :tests, :format if index_exists?(:tests, :format)
  end
end
