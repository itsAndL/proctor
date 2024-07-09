class CreateBusinesses < ActiveRecord::Migration[7.1]
  def change
    create_table :businesses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :contact_name
      t.string :contact_role
      t.string :company
      t.text :bio
      t.string :website

      t.timestamps
    end
  end
end
