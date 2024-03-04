class CreateBars < ActiveRecord::Migration[7.1]
  def change
    create_table :bars do |t|
      t.string :name
      t.string :description
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
