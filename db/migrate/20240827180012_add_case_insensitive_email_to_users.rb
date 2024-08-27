class AddCaseInsensitiveEmailToUsers < ActiveRecord::Migration[7.1]
  def up
    enable_extension 'citext' unless extension_enabled?('citext')
    change_column :users, :email, :citext
    remove_index :users, :email if index_exists?(:users, :email)
    add_index :users, :email, unique: true
  end

  def down
    change_column :users, :email, :string
    remove_index :users, :email if index_exists?(:users, :email)
    add_index :users, :email, unique: true
  end
end
