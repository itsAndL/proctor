class CreateCustomQuestionCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :custom_question_categories do |t|
      t.string :title

      t.timestamps
    end
  end
end
