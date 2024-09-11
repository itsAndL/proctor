class AddQuestionsToAnswerToTests < ActiveRecord::Migration[7.1]
  def change
    add_column :tests, :questions_to_answer, :integer
  end
end
