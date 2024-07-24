class CreateTestCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :test_categories do |t|
      t.string :title

      t.timestamps
    end

    add_reference :tests, :test_category, null: false, foreign_key: true
  end
end
