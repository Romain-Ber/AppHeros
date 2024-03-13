class AddImageIdToBarsAndUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :bars, :image_id, :string
    add_column :users, :image_id, :string
  end
end
