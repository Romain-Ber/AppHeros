class RemoveForeignKeyAddNearestBar < ActiveRecord::Migration[7.1]
  def change
    remove_reference :users, :bar
    add_column :users, :nearest_bar_id, :integer
  end
end
