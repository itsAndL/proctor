class CreateTests < ActiveRecord::Migration[7.1]
  def change
    create_table :tests do |t|
      t.string :title
      t.text :overview
      t.text :description
      t.integer :level
      t.json :covered_skills
      t.text :relevancy
      t.string :type
      t.references :test_category, null: false, foreign_key: true
      t.timestamps
    end

    add_index :tests, :title
  end
end
