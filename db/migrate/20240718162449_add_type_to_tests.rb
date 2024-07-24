class AddTypeToTests < ActiveRecord::Migration[7.1]
  def change
    add_column :tests, :type, :string
  end
end
