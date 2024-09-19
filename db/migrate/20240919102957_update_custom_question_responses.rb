class UpdateCustomQuestionResponses < ActiveRecord::Migration[7.1]
  def change
    change_table :custom_question_responses do |t|
      t.remove :duration_seconds
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :status, default: 0
    end
  end
end
