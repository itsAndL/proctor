class RemoveDurationSecondsFromQuestions < ActiveRecord::Migration[7.1]
  def change
    remove_column :questions, :duration_seconds, :integer
  end
end
