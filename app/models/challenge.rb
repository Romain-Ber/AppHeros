class Challenge < ApplicationRecord
  belongs_to :bar
  belongs_to :challenger, class_name: "User"
  belongs_to :challenged, class_name: "User"
  belongs_to :game

  belongs_to :winner, class_name: "User", optional: true
  belongs_to :loser, class_name: "User", optional: true

  has_many :messages
  validates :bar_id, :game_id, presence: true
end
