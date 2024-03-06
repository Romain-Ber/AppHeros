class AddBarIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :bar, foreign_key: true
  end
end
