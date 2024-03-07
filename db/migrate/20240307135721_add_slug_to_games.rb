class AddSlugToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :slug, :string
  end
end
