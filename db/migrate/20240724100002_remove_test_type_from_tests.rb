class RemoveTestTypeFromTests < ActiveRecord::Migration[7.1]
  def change
    # Remove the test_type_id column
    remove_reference :tests, :test_type, null: false, foreign_key: true

    # Drop the test_types table
    drop_table :test_types, if_exists: true do |t|
      t.string :title

      t.timestamps
    end
  end
end
