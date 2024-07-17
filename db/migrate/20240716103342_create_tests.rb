class CreateTests < ActiveRecord::Migration[7.1]
  def change
    create_table :test_types do |t|
      t.string :title

      t.timestamps
    end

    create_table :tests do |t|
      t.string :title
      t.text :overview
      t.text :description
      t.references :test_type, null: false, foreign_key: true
      t.integer :level
      t.integer :format
      t.json :covered_skills
      t.text :relevancy

      t.timestamps
    end

    add_index :tests, :title
  end
end
