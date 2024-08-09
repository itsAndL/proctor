class CreateAssessmentCustomQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :assessment_custom_questions do |t|
      t.references :assessment, null: false, foreign_key: true
      t.references :custom_question, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
