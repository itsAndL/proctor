class AddActiveAndIsCorrectToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :active, :boolean, default: true
    add_column :questions, :is_correct, :boolean
  end
end
