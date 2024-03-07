class Challenge < ApplicationRecord
  belongs_to :bar
  belongs_to :from, class_name: "User"
  belongs_to :to, class_name: "User"
  belongs_to :game
  validates :bar_id, :game_id, presence: true
end
