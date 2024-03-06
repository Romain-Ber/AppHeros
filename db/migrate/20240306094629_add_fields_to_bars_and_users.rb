class AddFieldsToBarsAndUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :bars, :bar_type, :string
    add_column :users, :first_login, :boolean
    add_column :users, :status, :string
  end
end
