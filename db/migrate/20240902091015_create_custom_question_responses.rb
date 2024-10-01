class CreateCustomQuestionResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :custom_question_responses do |t|
      t.references :assessment_participation, null: false, foreign_key: true
      t.references :custom_question, null: false, foreign_key: true
      t.integer :rating
      t.integer :duration_seconds, default: 0
      t.text :comment

      t.timestamps
    end

    add_index :custom_question_responses, %i[assessment_participation_id custom_question_id], unique: true, name: 'index_custom_question_responses_uniqueness'
  end
end
