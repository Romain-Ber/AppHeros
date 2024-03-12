class ChangeBooleanToStringInBars < ActiveRecord::Migration[7.1]
  def change
    change_column :bars, :outdoor_seats, :string
    change_column :bars, :wheelchair, :string
  end
end
