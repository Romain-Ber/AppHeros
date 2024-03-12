class AddFieldsToBars < ActiveRecord::Migration[7.1]
  def change
    add_column :bars, :opening_hours, :string
    add_column :bars, :phone, :string
    add_column :bars, :outdoor_seats, :boolean
    add_column :bars, :wheelchair, :boolean
    add_column :bars, :website, :string
    add_column :bars, :email, :string
  end
end
