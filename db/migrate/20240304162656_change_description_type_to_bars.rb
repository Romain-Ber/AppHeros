class ChangeDescriptionTypeToBars < ActiveRecord::Migration[7.1]
  def change
    remove_column :bars, :description
    add_column :bars, :description, :text
  end
end
