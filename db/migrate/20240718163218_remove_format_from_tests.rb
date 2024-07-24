class RemoveFormatFromTests < ActiveRecord::Migration[7.1]
  def change
    remove_index :tests, :format if index_exists?(:tests, :format)
    remove_column :tests, :format, :integer
  end
end
