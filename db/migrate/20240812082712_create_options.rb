class CreateOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :options do |t|
      t.boolean :correct, default: false
      t.references :optionable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
