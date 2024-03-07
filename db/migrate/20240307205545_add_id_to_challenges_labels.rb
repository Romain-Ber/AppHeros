class AddIdToChallengesLabels < ActiveRecord::Migration[7.1]
  def change
    rename_column :challenges, :challenger, :challenger_id
    rename_column :challenges, :challenged, :challenged_id
  end
end
