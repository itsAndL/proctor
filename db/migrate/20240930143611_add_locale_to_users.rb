class AddLocaleToUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :locale, :integer, default: 0
  end

  def down
    remove_column :users, :locale
  end
end
