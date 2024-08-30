class CreateQuestionAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :question_answers do |t|
      t.references :assessment_participation, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :test, null: false, foreign_key: true
      t.jsonb :content, null: false, default: {}
      t.boolean :is_correct

      t.timestamps
    end

    add_index :question_answers, :content, using: :gin
    add_index :question_answers, [:assessment_participation_id, :question_id, :test_id], unique: true, name: 'index_question_answers_on_participation_question_and_test'
  end
end
