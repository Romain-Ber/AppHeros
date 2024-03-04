class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :username, :string
    add_column :users, :age, :integer
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :description, :text
  end
end
