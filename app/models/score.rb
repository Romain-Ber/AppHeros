class Score < ApplicationRecord
  belongs_to :bar
  belongs_to :user
end
