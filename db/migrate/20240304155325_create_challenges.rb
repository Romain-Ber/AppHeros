class CreateChallenges < ActiveRecord::Migration[7.1]
  def change
    create_table :challenges do |t|
      t.references :bar, null: false, foreign_key: true
      t.string :location
      t.string :status
      t.float :winner_score
      t.float :loser_score

      t.timestamps
    end
  end
end
