class CreateAssessmentTests < ActiveRecord::Migration[7.1]
  def change
    create_table :assessment_tests do |t|
      t.references :assessment, null: false, foreign_key: true
      t.references :test, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
