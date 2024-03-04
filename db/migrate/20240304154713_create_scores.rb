class CreateScores < ActiveRecord::Migration[7.1]
  def change
    create_table :scores do |t|
      t.references :bar, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.float :score

      t.timestamps
    end
  end
end
