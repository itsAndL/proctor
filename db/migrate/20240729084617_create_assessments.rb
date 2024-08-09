class CreateAssessments < ActiveRecord::Migration[7.1]
  def change
    create_table :assessments do |t|
      t.string :title
      t.integer :language
      t.references :business, null: false, foreign_key: true

      t.timestamps
    end
  end
end
