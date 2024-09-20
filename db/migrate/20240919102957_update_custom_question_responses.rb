class UpdateCustomQuestionResponses < ActiveRecord::Migration[7.1]
  def up
    change_table :custom_question_responses do |t|
      t.remove :duration_seconds
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :status, default: 0
    end
  end

  def down
    change_table :custom_question_responses do |t|
      t.integer :duration_seconds, default: 0
      t.remove :started_at
      t.remove :completed_at
      t.remove :status
    end
  end
end
