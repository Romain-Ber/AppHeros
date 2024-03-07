class AddGameIdToChallenges < ActiveRecord::Migration[7.1]
  def change
    add_reference :challenges, :game, null: false, foreign_key: true
  end
end
