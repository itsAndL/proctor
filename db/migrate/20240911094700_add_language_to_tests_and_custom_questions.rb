class AddLanguageToTestsAndCustomQuestions < ActiveRecord::Migration[7.1]
  def change
    add_column :tests, :language, :integer, default: 0
    add_column :custom_questions, :language, :integer, default: 0

    add_index :tests, :language
    add_index :custom_questions, :language
  end
end
