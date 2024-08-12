class DropQuestionOptions < ActiveRecord::Migration[7.1]
  def up
    drop_table :question_options
  end

  def down
    create_table :question_options do |t|
      t.boolean :correct, default: false
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
