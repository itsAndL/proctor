class RemoveEsAndDeFromUserLocalEnum < ActiveRecord::Migration[7.1]
  def up
    User.where(locale: %i[es de]).update_all(locale: :fr)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
