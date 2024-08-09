class CreateCustomQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :custom_questions do |t|
      t.string :title
      t.text :relevancy
      t.text :look_for
      t.integer :duration_seconds, default: 0
      t.string :type
      t.integer :position
      t.references :custom_question_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
