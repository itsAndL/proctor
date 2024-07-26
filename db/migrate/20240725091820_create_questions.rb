class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.boolean :preview, default: false
      t.string :type

      t.timestamps
    end
  end
end
