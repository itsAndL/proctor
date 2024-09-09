class AddBusinessToCustomQuestions < ActiveRecord::Migration[7.1]
  def change
    add_reference :custom_questions, :business, null: true, foreign_key: true
  end
end
