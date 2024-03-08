class ChangeFromAndToInChallenges < ActiveRecord::Migration[7.1]
  def change
    rename_column :challenges, :from_id, :challenger
    rename_column :challenges, :to_id, :challenged
  end
end
