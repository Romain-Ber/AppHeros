class Challenge < ApplicationRecord
  belongs_to :bar
  belongs_to :challenger, class_name: "User"
  belongs_to :challenged, class_name: "User"
  belongs_to :game
  validates :bar_id, :game_id, presence: true
end
