class AddReferencesToChallenges < ActiveRecord::Migration[7.1]
  def change
    add_reference :challenges, :from, foreign_key: { to_table: :users }
    add_reference :challenges, :to, foreign_key: { to_table: :users }
    add_reference :challenges, :winner, foreign_key: { to_table: :users }
    add_reference :challenges, :loser, foreign_key: { to_table: :users }
  end
end
